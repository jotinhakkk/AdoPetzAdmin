<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Inicializa a variável de mensagem de erro  
    String messageError = "";
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    HttpSession userSession = request.getSession();
    Connection connection = null;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        if (email != null && senha != null && !email.trim().isEmpty() && !senha.trim().isEmpty()) {
            try {
                String dbUrl = "jdbc:mysql://localhost:3306/adopetz";
                String dbUser = "root";
                String dbPassword = "root";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                if (connection != null && !connection.isClosed()) {
                    // Primeiro, tente autenticar como super_administrador
                    String sqlSuperAdmin = "SELECT senha FROM super_administrador WHERE email = ?";
                    PreparedStatement stmtSuperAdmin = connection.prepareStatement(sqlSuperAdmin);
                    stmtSuperAdmin.setString(1, email);
                    ResultSet resultSetSuperAdmin = stmtSuperAdmin.executeQuery();

                    if (resultSetSuperAdmin.next()) {
                        String storedPassword = resultSetSuperAdmin.getString("senha");
                        if (senha.equals(storedPassword)) {
                            userSession.setAttribute("email", email);
                            userSession.setAttribute("tipo", "super_admin");
                            response.sendRedirect("admin-dashboard.jsp");
                            return;
                        } else {
                            messageError = "E-mail ou senha incorretos.";
                        }
                    } else {
                        // Se não for super_administrador, tente autenticar como administrador
                        String sqlAdmin = "SELECT senha FROM administrador WHERE email = ?";
                        PreparedStatement stmtAdmin = connection.prepareStatement(sqlAdmin);
                        stmtAdmin.setString(1, email);
                        ResultSet resultSetAdmin = stmtAdmin.executeQuery();

                        if (resultSetAdmin.next()) {
                            String storedPassword = resultSetAdmin.getString("senha");
                            if (senha.equals(storedPassword)) {
                                userSession.setAttribute("email", email);
                                userSession.setAttribute("tipo", "admin");
                                response.sendRedirect("dashboardadmincomum.jsp");
                                return;
                            } else {
                                messageError = "E-mail ou senha incorretos.";
                            }
                        } else {
                            messageError = "E-mail não encontrado.";
                        }
                    }
                } else {
                    messageError = "Erro ao conectar com o banco de dados: conexão fechada.";
                }

            } catch (Exception e) {
                e.printStackTrace();
                messageError = "Erro ao conectar com o banco de dados: " + e.getMessage();
            } finally {
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (Exception e) {
                        messageError = "Erro ao fechar a conexão: " + e.getMessage();
                    }
                }
            }
        } else {
            messageError = "Por favor, preencha todos os campos.";
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<link rel="stylesheet" href="logi">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado do Login</title>
    
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap');

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Outfit', sans-serif;
}

body, html {
    height: 100%;
    background-color: #0011a8;
    display: flex;
    align-items: center;
    justify-content: center;
}

.container {
    background-color: #ffffff;
    width: 350px;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    text-align: center;
    transition: box-shadow 0.3s ease-in-out;
}

.container:hover {
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
}

.container h1 {
    color: #0011a8;
    font-weight: 900;
    margin-bottom: 20px;
    letter-spacing: 1.5px;
}

#error-message {
    color: #ff0033;
    font-size: 1rem;
    margin-bottom: 20px;
}

a {
    display: inline-block;
    font-size: 1rem;
    line-height: 2rem;
    font-weight: 600;
    text-transform: uppercase;
    width: 80%;
    padding: 0.75rem 1.5rem;
    background-color: #2e43fa;
    color: #ffffff;
    border: none;
    border-radius: 8px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 5px 15px rgba(46, 67, 250, 0.4);
    cursor: pointer;
}

a:hover {
    background-color: #0011a8;
    box-shadow: 0 8px 20px rgba(0, 17, 168, 0.5);
    transform: translateY(-3px);
}
    </style>
    
</head>
<body>
    <div class="container">
        <h1>Resultado do Login</h1>
        <div id="error-message">
            <%= messageError != null && !messageError.isEmpty() ? messageError : "" %>
        </div>
        <a href="../CadastroAdministrador/login.html">Voltar ao Login</a>
    </div>
</body>
</html>
