package br.ufrpe.libelula.gui;

import javax.swing.JOptionPane;

import br.ufrpe.libelula.negocio.gerenciamento.Fachada;
import javafx.application.Application;
import javafx.stage.Stage;

public class MainGUI extends Application {

	@Override
	public void start(Stage primaryStage) throws Exception {
		try {
			//Fachada.getInstance().conexao("superuser", "12345");
		} catch (Exception e) {
			JOptionPane.showMessageDialog(null, e.getMessage());
			throw new Exception(e);
		}
		ScreenManager.getInstance().setMainStage(primaryStage);
		//ScreenManager.getInstance().showLogin();
		 ScreenManager.getInstance().showMenuPrincipal();


	}

	public static void main(String[] args) {
		launch(args);
	}
}