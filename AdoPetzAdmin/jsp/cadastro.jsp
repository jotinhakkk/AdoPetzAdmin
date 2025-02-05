<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null) {
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
            if (request.getParameter("submit") != null) {
                // Dados do formulário do usuário
                String nome = request.getParameter("nome");
                String email = request.getParameter("email");
                String cpf = request.getParameter("cpf").replaceAll("[^\\d]", ""); // Remove caracteres não numéricos
                String cep = request.getParameter("cep").replaceAll("[^\\d]", ""); // Remove caracteres não numéricos
                String telefone = request.getParameter("telefone").replaceAll("[^\\d]", ""); // Remove caracteres não numéricos
                String senha = request.getParameter("senha");
                String estado = request.getParameter("estado");

                // Validar se os campos obrigatórios estão preenchidos
                if (nome != null && email != null && cpf != null && cep != null && telefone != null &&
                    senha != null && estado != null && !estado.isEmpty()) {

                    // Verificar se o CPF ou o e-mail já estão registrados
                    String checkQuery = "SELECT 1 FROM usuario WHERE cpf = ? OR email = ?";
                    try (PreparedStatement pstmtCheck = connection.prepareStatement(checkQuery)) {
                        pstmtCheck.setString(1, cpf);
                        pstmtCheck.setString(2, email);

                        if (pstmtCheck.executeQuery().next()) {
                            messageCadastro = "CPF ou e-mail já estão registrados.";
                        } else {
                            // Verificar se o CEP existe no banco de dados
                            String checkCepQuery = "SELECT 1 FROM usuario WHERE cep = ?";
                            try (PreparedStatement pstmtCheckCep = connection.prepareStatement(checkCepQuery)) {
                                pstmtCheckCep.setString(1, cep);
                                if (pstmtCheckCep.executeQuery().next()) {
                                    messageCadastro = "O CEP informado já está cadastrado.";
                                } else {
                                    // Verificar se o telefone já existe no banco de dados
                                    String checkTelefoneQuery = "SELECT 1 FROM usuario WHERE telefone = ?";
                                    try (PreparedStatement pstmtCheckTelefone = connection.prepareStatement(checkTelefoneQuery)) {
                                        pstmtCheckTelefone.setString(1, telefone);
                                        if (pstmtCheckTelefone.executeQuery().next()) {
                                            messageCadastro = "O telefone informado já está cadastrado.";
                                        } else {
                                            // Inserir os dados do usuário no banco de dados
                                            String insertQuery = "INSERT INTO usuario (nome, email, cpf, cep, telefone, senha, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
                                            try (PreparedStatement pstmtInsert = connection.prepareStatement(insertQuery)) {
                                                pstmtInsert.setString(1, nome);
                                                pstmtInsert.setString(2, email);
                                                pstmtInsert.setString(3, cpf);
                                                pstmtInsert.setString(4, cep);
                                                pstmtInsert.setString(5, telefone);
                                                pstmtInsert.setString(6, senha); // Certifique-se de armazenar um hash da senha!
                                                pstmtInsert.setString(7, estado);

                                                if (pstmtInsert.executeUpdate() > 0) {
                                                    isSuccess = true;
                                                    messageCadastro = "Cadastro realizado com sucesso!";
                                                } else {
                                                    messageCadastro = "Erro ao realizar o cadastro.";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    messageCadastro = "Todos os campos obrigatórios devem ser preenchidos.";
                }
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
    <title>Cadastro de Usuário</title>
    <link rel="shortcut icon" href="../Images/favicon.ico" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="login">
            <h1>Cadastro de Usuário</h1>
            <h3>Insira os Dados</h3>
            <!-- Formulário do Usuário -->
            <form id="formUsuario" action="<%= request.getRequestURI() %>" method="post">
                <input type="text" placeholder="Nome" id="nome" name="nome" required>
                <input type="email" placeholder="E-mail" id="email" name="email" required>
                <input type="text" placeholder="CPF" id="cpf" name="cpf" required oninput="formatarCPF(this)" maxlength="14">
                <input type="text" placeholder="CEP" id="cep" name="cep" required oninput="formatarCEP(this)" maxlength="9">
                <input type="tel" placeholder="Ex: (21) 12345-6789" id="telefone" name="telefone" required maxlength="20">
                <input type="password" placeholder="Senha" id="senha" name="senha" required>
                <label for="estado">Estado:</label>
                <select id="estado" name="estado" required>
                    <option value="">Selecione o Estado</option>
                    <option value="AC">Acre</option>
                    <option value="AL">Alagoas</option>
                    <option value="AP">Amapá</option>
                    <option value="AM">Amazonas</option>
                    <option value="BA">Bahia</option>
                    <option value="CE">Ceará</option>
                    <option value="DF">Distrito Federal</option>
                    <option value="ES">Espírito Santo</option>
                    <option value="GO">Goiás</option>
                    <option value="MA">Maranhão</option>
                    <option value="MT">Mato Grosso</option>
                    <option value="MS">Mato Grosso do Sul</option>
                    <option value="MG">Minas Gerais</option>
                    <option value="PA">Pará</option>
                    <option value="PB">Paraíba</option>
                    <option value="PR">Paraná</option>
                    <option value="PE">Pernambuco</option>
                    <option value="PI">Piauí</option>
                    <option value="RJ">Rio de Janeiro</option>
                    <option value="RN">Rio Grande do Norte</option>
                    <option value="RS">Rio Grande do Sul</option>
                    <option value="RO">Rondônia</option>
                    <option value="RR">Roraima</option>
                    <option value="SC">Santa Catarina</option>
                    <option value="SP">São Paulo</option>
                    <option value="SE">Sergipe</option>
                    <option value="TO">Tocantins</option>
                </select>
                <button type="submit" name="submit">Cadastrar</button>
            </form>
            <br>
            <a href="<%= "super_admin".equals(userSession.getAttribute("tipo")) ? "admin-dashboard.jsp" : "dashboardadmincomum.jsp" %>" class="button">Voltar ao Painel de Controle</a>
        </div>
    </div>
    <script>
        // Exibe a mensagem em um pop-up se houver uma mensagem de cadastro
        <%= !messageCadastro.isEmpty() ? "alert('" + messageCadastro.replace("'", "\\'") + "');" : "" %>
    </script>
</body>
</html>
