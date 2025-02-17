--[5] 그룹함수
--SUM, AVG, MIN, MAX, COUNT, STDDEV, VARIANCE
--단일행 함수와 함께 쓸 수 없다
--GROUP FUNC
SELECT SUM(SAL) 
    FROM EMP; --합
SELECT DEPTNO, SUM(SAL) 
    FROM EMP 
    GROUP BY DEPTNO; --단일행 사용시 GROUP 절 필요
SELECT ROUND(AVG(SAL), 2) 
    FROM EMP; --평균
SELECT COUNT(SAL) 
    FROM EMP;--행수 
SELECT AVG(SAL), SUM(SAL)/COUNT(SAL) 
    FROM EMP;
SELECT AVG(COMM), SUM(COMM)/COUNT(COMM) 
    FROM EMP;--그룹함수는 NULL 제외
SELECT ROUND(AVG(SAL),2), SUM(SAL), COUNT(SAL), MIN(SAL), MAX(SAL), ROUND(VARIANCE(SAL),2), ROUND(STDDEV(SAL),2) 
    FROM EMP;
SELECT DEPTNO 부서번호, MAX(SAL) 
    FROM EMP 
    GROUP BY DEPTNO; --GROUP절에는 ALIAS 사용 불가능
SELECT MIN(HIREDATE), MAX(HIREDATE), DEPTNO 
    FROM EMP 
    GROUP BY DEPTNO;
SELECT COUNT(DISTINCT JOB) 
    FROM EMP;--중복 제거
SELECT MAX(HIREDATE)||':'||TRUNC(SYSDATE-MAX(HIREDATE))||'일째  '|| MIN(HIREDATE)||':'||TRUNC(SYSDATE-MIN(HIREDATE))||'일째' 
    FROM EMP;
SELECT MAX(HIREDATE)||':'||TO_CHAR(TRUNC(SYSDATE-MAX(HIREDATE)), '99,999')||'일째  '|| MIN(HIREDATE)||':'||TO_CHAR(TRUNC(SYSDATE-MIN(HIREDATE)), '99,999')||'일째' 
    FROM EMP;
SELECT ROUND(AVG(SAL)) 
    FROM EMP  
    WHERE DEPTNO = '10';
--GROUP BY
SELECT DEPTNO, MAX(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO, COUNT(*), MAX(SAL), MIN(SAL), ROUND(AVG(SAL)) 
    FROM EMP 
    GROUP BY DEPTNO; 
SELECT DNAME, COUNT(*), MAX(SAL), MIN(SAL), ROUND(AVG(SAL)) 
    FROM EMP E, DEPT D 
    WHERE E.DEPTNO = D.DEPTNO 
    GROUP BY DNAME;
--HAVING
SELECT DEPTNO, ROUND(AVG(SAL)) 
    FROM EMP 
    GROUP BY DEPTNO
    HAVING ROUND(AVG(SAL))>=2000;--HAVING절 > AVG(SAL)가 2000이상인 부서만 출력
    
--피벗 테이블
SELECT DEPTNO, JOB, SUM(SAL) 
    FROM EMP
    GROUP BY DEPTNO, JOB; --가독성이 떨어짐
SELECT DEPTNO, SUM(DECODE(JOB, 'CLERK', SAL, 0)) CLERK, 
               SUM(DECODE(JOB, 'MANAGER', SAL, 0)) MANAGER,
               SUM(DECODE(JOB, 'PRESIDENT', SAL, 0)) PRESIDENT,
               SUM(DECODE(JOB, 'ANALYST', SAL, 0)) ANALYST,
               SUM(DECODE(JOB, 'SALESMAN', SAL, 0)) SALESMAN
               FROM EMP
               GROUP BY DEPTNO;--피벗테이블
SELECT DEPTNO, SUM(DECODE(JOB, 'CLERK', SAL, 0)) CLERK, 
               SUM(DECODE(JOB, 'MANAGER', SAL, 0)) MANAGER,
               SUM(DECODE(JOB, 'PRESIDENT', SAL, 0)) PRESIDENT,
               SUM(DECODE(JOB, 'ANALYST', SAL, 0)) ANALYST,
               SUM(DECODE(JOB, 'SALESMAN', SAL, 0)) SALESMAN,
               SUM(SAL) TOTAL
               FROM EMP
               GROUP BY ROLLUP(DEPTNO);--합계 추가(ROLLUP - 합계)               
               
--ex)
-- 1. 사원 테이블에서 인원수,최대 급여,최소 급여,급여의 합을 계산하여 출력
SELECT COUNT(*), MAX(SAL), MIN(SAL), SUM(SAL) 
    FROM EMP;
-- 2. 사원테이블에서 업무별 인원수를 구하여 출력하는 SELECT 문장을 작성하여라.
SELECT COUNT(*), DEPTNO 
    FROM EMP 
    GROUP BY DEPTNO;
--- 3. 사원테이블에서 최고 급여와 최소 급여의 차이는 얼마인가 출력하는 SELECT문장을 작성하여라.
SELECT MAX(SAL)-MIN(SAL) 
    FROM EMP;
-- 4. 각 부서별로 인원수, 급여 평균, 최저 급여, 최고 급여, 급여의 합을 출력하되 급여의 합이 많은 순으로 출력하라.
SELECT DEPTNO, COUNT(*), ROUND(AVG(SAL)), MIN(SAL), MAX(SAL), SUM(SAL) 
    FROM EMP
    GROUP BY DEPTNO
    ORDER BY SUM(SAL) DESC;
-- 5. 부서별, 업무별 그룹하여 결과를 부서번호, 업무, 인원수, 급여의 평균, 급여의 합을 
    --구하여 출력하라(출력결과는 부서번호, 업무순으로 오름차순 정렬)
SELECT DEPTNO, JOB, COUNT(*), ROUND(AVG(SAL)), SUM(SAL) 
    FROM EMP
    GROUP BY DEPTNO, JOB
    ORDER BY DEPTNO, JOB;
-- 6. 업무별, 부서별 그룹하여 결과를  업무, 부서번호, 인원수, 급여의 평균, 급여의 합을 구하여 
-- 출력하라.(출력결과는 업무순, 부서번호 순 오름차순 정렬)
SELECT JOB, DEPTNO, COUNT(*), ROUND(AVG(SAL)), SUM(SAL) 
    FROM EMP
    GROUP BY JOB, DEPTNO
    ORDER BY JOB, DEPTNO;
--7. 사원수가 5명이상 넘는 부서번호와 사원수를 출력하시오.
SELECT DEPTNO, COUNT(*) 
    FROM EMP
    GROUP BY DEPTNO
    HAVING COUNT(*)>5;
-- 8. 사원수가 5명이상 넘는 부서명과 사원수를 출력하시오
SELECT DNAME, COUNT(*) 
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    GROUP BY DNAME
    HAVING COUNT(*)>5;
--9. 사원 테이블에서 업무별 급여의 평균이 3000이상인 업무에 대해서 업무명, 평균 급여, 
--급여의 합을 구하여 출력하라
SELECT JOB, ROUND(AVG(SAL)), SUM(SAL) 
    FROM EMP
    GROUP BY JOB
    HAVING ROUND(AVG(SAL))>=3000;
--10. 사원테이블에서 급여합이 5000을 초과하는 각 업무에 대해서 업무와 급여합계를 출력하라 
        --단, 급여 합계로 내림차순 정렬하라.
SELECT JOB, SUM(SAL) 
    FROM EMP
    GROUP BY JOB
    HAVING SUM(SAL)>5000
    ORDER BY SUM(SAL) DESC;
--11. 부서별 급여평균, 부서별 급여합계, 부서별 최소급여를 출력하라.
SELECT DEPTNO, ROUND(AVG(SAL)), MIN(SAL) 
    FROM EMP
    GROUP BY DEPTNO;
--12. 위의 11번을 수정하여, 부서별 급여평균 최대치, 부서별 급여합의 최대치, 
            --부서별 최소급여의 최대치를 출력하라.
SELECT ROUND(MAX(AVG(SAL))), MAX(SUM(SAL)), MAX(MIN(SAL)) 
    FROM EMP
    GROUP BY DEPTNO;
--13. 사원 테이블에서 아래의 결과를 출력하는 SELECT 문장을 작성하여라.(년도별 연봉합)
--   H_YEAR	COUNT(*)	MIN(SAL)	MAX(SAL)	AVG(SAL)	SUM(SAL)
--     80	  1		    800		    800		    800		    800
--	81	 10		    950		    5000	    2282.5	  22825
--	82	  2		    1300	    3000	   2150		   4300
--	83	  1		    1100	    1100	    1100	   1100
SELECT TO_CHAR(HIREDATE, 'YY') "YEAR", COUNT(*), MIN(SAL), MAX(SAL), ROUND(AVG(SAL)), SUM(SAL) 
    FROM EMP
    GROUP BY TO_CHAR(HIREDATE, 'YY')
    ORDER BY YEAR;
-- 14.  사원테이블에서 아래의 결과를 출력하는 SELECT 문 작성
-- TOTAL	1980	1981	1982	1983
--  14		  1	     10	      2	      1
SELECT SUM(COUNT(*)) "TOTAL",
       SUM(DECODE(TO_CHAR(HIREDATE, 'YYYY'), '1980', COUNT(*))) "1980",
       SUM(DECODE(TO_CHAR(HIREDATE, 'YYYY'), '1981', COUNT(*))) "1981",
       SUM(DECODE(TO_CHAR(HIREDATE, 'YYYY'), '1982', COUNT(*))) "1982",
       SUM(DECODE(TO_CHAR(HIREDATE, 'YYYY'), '1983', COUNT(*))) "1983"
       FROM EMP
       GROUP BY TO_CHAR(HIREDATE, 'YYYY');
--15. 사원테이블에서 아래의 결과를 출력하는 SELECT 문 작성(JOB 순으로 오름차순 정렬)
-- JOB별, DEPTNO별 SUM(SAL)
--JOB		DEPTNO10	DEPTNO20	DEPTNO30     TOTAL
--ANALYST	     0		   6000		    0		6000
--CLERK		  1300		   1900		  950		4150
--….
--SALESMAN	      0	 		0	 5600		 5600
SELECT JOB, SUM(DECODE(DEPTNO, 10, SAL, 0)) DEPTNO10, 
            SUM(DECODE(DEPTNO, 20, SAL, 0)) DEPTNO20,
            SUM(DECODE(DEPTNO, 30, SAL, 0)) DEPTNO30, 
            SUM(SAL) TOTAL
            FROM EMP
            GROUP BY JOB
            ORDER BY TOTAL DESC;
--16. 사원테이블에서 최대급여, 최소급여, 전체급여합, 평균을 구하시오
SELECT MAX(SAL), MIN(SAL), SUM(SAL), ROUND(AVG(SAL)) 
    FROM EMP;
--17. 사원테이블에서 부서별 인원수를 구하시오
SELECT DEPTNO, COUNT(*)
    FROM EMP
    GROUP BY DEPTNO;
--18. 사원 테이블에서 부서별 인원수가 6명이상인 부서코드를 구하시오
SELECT DEPTNO, COUNT(*)
    FROM EMP
    GROUP BY DEPTNO
    HAVING COUNT(*)>=6;
--19. 사원테이블에서 다음과 같은 결과가 나오게 하시오
--DNAME               CLERK    MANAGER     PRESIDENT    ANALYST   SALESMAN
--ACCOUNTING            1300       2450       5000          0          0
--RESEARCH              1900       2975          0       6000          0
--SALES                 950        2850          0          0       5600
SELECT DNAME, SUM(DECODE(JOB, 'CLERK', SAL, 0)) CLERK, 
              SUM(DECODE(JOB, 'MANAGER', SAL, 0)) MANAGER,
              SUM(DECODE(JOB, 'PRESIDENT', SAL, 0)) PRESIDENT,
              SUM(DECODE(JOB, 'ANALYST', SAL, 0)) ANALYST,
              SUM(DECODE(JOB, 'SALEMAN', SAL, 0)) SALESMAN
              FROM EMP E, DEPT D
              WHERE E.DEPTNO = D.DEPTNO
              GROUP BY DNAME
              
--20.  사원테이블에서 급여가 높은 순서대로 등수를 부여하여 다음과 같은 결과가 나오게 하시오. 
-- (힌트 self join, group by, count사용)
--ENAME	    등수
--________________________
--KING		1
--SCOTT		2
--……
SELECT E1.ENAME, COUNT(E2.ENAME)+1 등수
    FROM EMP E1, EMP E2 
    WHERE E1.SAL < E2.SAL(+) 
    GROUP BY E1.ENAME
    ORDER BY 등수;

SELECT ENAME, SAL,
    RANK() OVER(ORDER BY SAL DESC) "RANKING",
    DENSE_RANK() OVER(ORDER BY SAL DESC) "D_RANKING",
    ROW_NUMBER() OVER(ORDER BY SAL DESC) "R_RANKING"
    FROM EMP;
    

               