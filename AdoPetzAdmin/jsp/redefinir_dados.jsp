<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException, java.sql.ResultSet" %>
<%@ include file="conexao.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }

    String email = request.getParameter("email");
    String nome = request.getParameter("nome");
    String cpf = request.getParameter("cpf_cnpj");
    String cep = request.getParameter("cep");
    String telefone = request.getParameter("telefone");
    String senha = request.getParameter("senha");
    String estado = request.getParameter("estado");
    Connection connection = (Connection) pageContext.getAttribute("messageConnection");

    String statusMessage = "";

    // Executar a lógica de atualização apenas se o método da requisição for POST
    if ("POST".equalsIgnoreCase(request.getMethod()) && email != null && !email.isEmpty()) {
        try {
            if (connection != null) {
                // Verificar se o e-mail existe na tabela `usuario`
                String sql = "SELECT 1 FROM usuario WHERE email = ?";
                PreparedStatement stmt = connection.prepareStatement(sql);
                stmt.setString(1, email);
                ResultSet resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    // Atualizar os dados do usuário
                    sql = "UPDATE usuario SET nome = ?, cpf = ?, cep = ?, telefone = ?, senha = ?, estado = ? WHERE email = ?";
                    PreparedStatement updateStmt = connection.prepareStatement(sql);
                    updateStmt.setString(1, nome);
                    updateStmt.setString(2, cpf);
                    updateStmt.setString(3, cep);
                    updateStmt.setString(4, telefone);
                    updateStmt.setString(5, senha);
                    updateStmt.setString(6, estado);
                    updateStmt.setString(7, email);

                    int rowsUpdated = updateStmt.executeUpdate();
                    statusMessage = rowsUpdated > 0 ? "success" : "error";
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
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualizar Dados do Usuário</title>
    <link rel="stylesheet" href="../css/redefinir.css">
</head>
<body>
    <div class="container form-container">
        <h1>Atualizar Dados do Usuário</h1>
        <form action="redefinir_dados.jsp" method="post">
            <input type="email" placeholder="E-mail" id="email" name="email" required>
            <input type="text" placeholder="Nome" id="nome" name="nome" required>
            <input type="text" placeholder="CPF" id="cpf" name="cpf_cnpj" required maxlength="14">
            <input type="text" placeholder="CEP" id="cep" name="cep" required maxlength="8">
            <input type="tel" placeholder="Telefone" id="telefone" name="telefone" required maxlength="11">
            <input type="password" placeholder="Senha" id="senha" name="senha" required>
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
            <button class="inputSubmit" type="submit">Atualizar Dados</button>
            <a href="<%= "super_admin".equals(userSession.getAttribute("tipo")) ? "admin-dashboard.jsp" : "dashboardadmincomum.jsp" %>" class="button">Voltar ao Painel de Controle</a>
        </form>
    </div>
    <script>
        // Exibir mensagem baseada no status da operação
        (function showMessage() {
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
        })();
    </script>
</body>
</html>
