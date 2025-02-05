<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%

    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroCliente/login.html");
        return;
    }
%>
<%
    String email = request.getParameter("email");
    String nome = request.getParameter("nome");
    String cpf = request.getParameter("cpf");
    String cep = request.getParameter("cep");
    String telefone = request.getParameter("telefone");
    String senha = request.getParameter("senha");
    Connection connection = (Connection) pageContext.getAttribute("messageConnection");

    String statusMessage = "";

    if (request.getMethod().equalsIgnoreCase("POST") && email != null && !email.isEmpty()) {
        try {
            if (connection != null) {
                boolean emailExistente = false;

                // Verificar se o e-mail existe na tabela de administrador
                String sql = "SELECT 1 FROM administrador WHERE email = ?";
                PreparedStatement stmt = connection.prepareStatement(sql);
                stmt.setString(1, email);
                ResultSet resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    // Atualizar dados na tabela de administrador
                    sql = "UPDATE administrador SET nome = ?, cpf = ?, cep = ?, telefone = ?, senha = ? WHERE email = ?";
                    PreparedStatement updateStmt = connection.prepareStatement(sql);
                    updateStmt.setString(1, nome);
                    updateStmt.setString(2, cpf);
                    updateStmt.setString(3, cep);
                    updateStmt.setString(4, telefone);
                    updateStmt.setString(5, senha);
                    updateStmt.setString(6, email);
                    int rowsUpdated = updateStmt.executeUpdate();
                    emailExistente = true;
                }

                if (emailExistente) {
                    statusMessage = "success";
                } else {
                    statusMessage = "email_not_found";
                }
            } else {
                statusMessage = "db_connection_error";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            statusMessage = "sql_error";
        }
    } else {
        statusMessage = "missing_fields";
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualizar Dados</title>
    <link rel="stylesheet" href="../css/redefinir.css">
    <link rel="shortcut icon" href="../Images/favicon.ico" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    
    <div class="container form-container">
        <h1>Atualizar Dados</h1>
        
        <form id="formAdministrador" action="redefinir-dados-admin.jsp" method="post">
            <input type="text" placeholder="Nome" id="nomeAdm" name="nome" required>
            <input type="email" placeholder="E-mail" id="emailAdm" name="email" required oninput="formatarEmail(this)">
            <input type="text" placeholder="CPF" id="cpfAdm" name="cpf" required oninput="formatarCPF(this)" maxlength="14">
            <input type="text" placeholder="CEP" id="cepAdm" name="cep" required oninput="formatarCEP(this)" maxlength="9">
            <input type="tel" placeholder="Ex: (21) 12345-6789" id="telefoneAdm" name="telefone" required>
            <input type="password" placeholder="Senha" id="senhaAdm" name="senha" required>
            <button class="inputSubmit" type="submit">Atualizar Dados</button>
            <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </form>
    </div>
    <script>
        // Função para mostrar a mensagem de resultado do JSP
        function showMessage() {
            const status = '<%= statusMessage %>';

            if (status === 'success') {
                alert('Dados atualizados com sucesso!');
            } else if (status === 'email_not_found') {
                alert('E-mail não encontrado.');
            } else if (status === 'db_connection_error') {
                alert('Erro na conexão com o banco de dados.');
            } else if (status === 'sql_error') {
                alert('Erro ao executar a operação no banco de dados.');
            }
        }
        window.onload = showMessage;

        // Funções para formatar campos
        function formatarCPF(cpf) {
            cpf.value = cpf.value
                .replace(/\D/g, "")
                .replace(/(\d{3})(\d)/, "$1.$2")
                .replace(/(\d{3})(\d)/, "$1.$2")
                .replace(/(\d{3})(\d{1,2})$/, "$1-$2");
        }

        function formatarCEP(cep) {
            cep.value = cep.value
                .replace(/\D/g, "")
                .replace(/(\d{5})(\d{1,3})$/, "$1-$2");
        }

        function formatarEmail(email) {
            email.value = email.value.trim();
        }
    </script>
</body>
</html>
