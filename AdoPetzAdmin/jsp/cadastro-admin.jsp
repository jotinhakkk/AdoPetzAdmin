<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>

<%@ page import="javax.servlet.http.HttpSession" %>
<%

    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }
%>
<%
    String messageCadastro = ""; // Mensagens relacionadas ao cadastro
    boolean isSuccess = false; // Para controlar o sucesso da operação

    // Obtém a conexão do contexto da página
    Connection connection = (Connection) pageContext.getAttribute("messageConnection");

    if (connection != null) {
        try {
            // Verifica qual botão de submit foi pressionado
            if (request.getParameter("submit1") != null) {
                // Dados do formulário de administrador
                String nome = request.getParameter("nome");
                String email = request.getParameter("email");
                String cpf = request.getParameter("cpf");
                String cep = request.getParameter("cep");
                String telefone = request.getParameter("telefone");
                String senha = request.getParameter("senha");

                if (nome != null && email != null && cpf != null && cep != null && telefone != null && senha != null) {
                    
                    // Verificar comprimento do CEP
                    if (cep.length() > 9) {
                        messageCadastro = "CEP não pode ter mais de 9 caracteres.";
                    } else {
                        // Verificar se o CPF já existe
                        String checkCpfQuery = "SELECT 1 FROM administrador WHERE cpf = ?";
                        try (PreparedStatement pstmt = connection.prepareStatement(checkCpfQuery)) {
                            pstmt.setString(1, cpf);

                            if (pstmt.executeQuery().next()) {
                                messageCadastro = "O CPF já está registrado.";
                            } else {
                                // Inserir dados no banco de dados
                                String insertQuery = "INSERT INTO administrador (cpf, nome, email, cep, telefone, senha) VALUES (?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement pstmtInsert = connection.prepareStatement(insertQuery)) {
                                    pstmtInsert.setString(1, cpf);
                                    pstmtInsert.setString(2, nome);
                                    pstmtInsert.setString(3, email);
                                    pstmtInsert.setString(4, cep);
                                    pstmtInsert.setString(5, telefone);
                                    pstmtInsert.setString(6, senha);

                                    if (pstmtInsert.executeUpdate() > 0) {
                                        isSuccess = true;
                                        messageCadastro = "Cadastro realizado com sucesso!";
                                    } else {
                                        messageCadastro = "Erro ao inserir registro.";
                                    }
                                }
                            }
                        }
                    }
                } else {
                    messageCadastro = "Todos os campos obrigatórios devem ser preenchidos.";
                }
            } else {
                messageCadastro = "Tipo de pessoa inválido.";
            }
        } catch (SQLException e) {
            messageCadastro = "Erro: " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        messageCadastro = "Não foi possível estabelecer uma conexão com o banco de dados.";
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/cadastro.css">
    <title>Cadastro</title>
    <link rel="shortcut icon" href="../Images/favicon.ico" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet">
    <script src="../CadastroAdministrador/js/alterarFormulario.js"></script>
</head>
<body>
   
    <div class="container">
        <div class="login">
            <h1>Cadastro Administrador</h1>
           

            
         

            <h3>Insira os Dados</h3>
            
            <!-- Formulário Pessoa Física -->
            <form id="formPessoaFisica" action="<%= request.getRequestURI() %>" method="post">
                <input type="text" placeholder="Nome" id="nomePF" name="nome" required>
                <input type="email" placeholder="E-mail" id="emailPF" name="email" required>
                <input type="text" placeholder="CPF" id="cpfPF" name="cpf" required oninput="formatarCPF(this)" maxlength="14">
                <input type="text" placeholder="CEP" id="cepPF" name="cep" required oninput="formatarCEP(this)" maxlength="9">
                <input type="tel" placeholder="Ex: (21) 12345-6789" id="telefonePF" name="telefone" required maxlength="11">
                <input type="password" placeholder="Senha" id="senhaPF" name="senha" required>
                
                <button type="submit" name="submit1">Cadastrar</button>
            </form>
            
            <br>
            <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </div>
    </div>
    <script>
        // Exibe a mensagem em um pop-up se houver uma mensagem de cadastro
        <%= isSuccess ? "alert('" + messageCadastro.replace("'", "\\'") + "');" : "" %>
    </script>
</body>
</html>
