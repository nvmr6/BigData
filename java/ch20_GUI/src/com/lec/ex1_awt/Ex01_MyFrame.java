package com.lec.ex1_awt;

import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Dimension;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class Ex01_MyFrame extends Frame {
	private Button btn, btn1;

	public Ex01_MyFrame(String title) {
		//버튼 2개 추가된 프레임 생성
		super(title);
		btn = new Button("버튼");
		btn1 = new Button("그냥 버튼");
		add(btn, BorderLayout.NORTH);
		add(btn1, BorderLayout.CENTER);
		setVisible(true);
		setSize(new Dimension(300,200));
		setLocation(200,100);
		
		addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				setVisible(false);
				dispose();
				System.exit(0);
			}
		});
	}

	public Ex01_MyFrame() {
		this("");
	}
	public static void main(String[] args) {
		new Ex01_MyFrame("GUI");
	}
}
