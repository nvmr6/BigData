package com.lec.ex5delete;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class DeleteDept2 {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@127.0.0.1:1521:xe";
		Scanner sc = new Scanner(System.in);
		System.out.println("삭제할 부서번호: ");
		String deptno = sc.next();
		String selectquery = "SELECT * FROM DEPT WHERE DEPTNO="+deptno;
		Connection conn = null; 
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(url, "scott", "tiger");
			stmt = conn.createStatement();
			rs = stmt.executeQuery(selectquery);
			System.out.println("삭제하시겠습니까? (y/n)");
			if(rs.next()) {
				String ans = sc.next();
				if(ans.equals("y")) {
					String query =String.format("DELETE FROM DEPT WHERE DEPTNO = " + deptno);
					int result = stmt.executeUpdate(query);
					System.out.println(result>0? deptno+"번 부서 삭제":"해당 부서 존재하지 않음");
				}else {
					System.out.println("삭제 취소");
				}
			}else {
				System.out.println("유효하지 않은 부서 번호");
			}
		} catch (ClassNotFoundException e) {
			System.out.println(e.getMessage());
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally {
			try {
				if(stmt!=null) stmt.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				System.out.println(e.getMessage());
			}
	}
	sc.close();
	}
}
