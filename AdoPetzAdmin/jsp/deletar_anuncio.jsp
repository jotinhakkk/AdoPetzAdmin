<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Excluir Anúncio</title>
    <link rel="stylesheet" href="../css/excluiranuncio.css">
</head>
<body>
    <div class="container">
        <h1>Excluir Anúncio</h1>
        
        <form action="" method="post">
            <label for="id">ID do Anúncio:</label>
            <input type="number" name="id" id="id" placeholder="Digite o ID do Anúncio" required>

            <label for="anunciante_nome">Nome do Anunciante:</label>
            <input type="text" name="anunciante_nome" id="anunciante_nome" placeholder="Digite o Nome do Anunciante" required>

            <input type="submit" value="Excluir Anúncio">
        </form>

        <div class="result-message">
            <%
                String anuncioId = request.getParameter("id");
                String anuncianteNome = request.getParameter("anunciante_nome");

                if (anuncioId != null && anuncianteNome != null && !anuncioId.isEmpty() && !anuncianteNome.isEmpty()) {
                    String url = "jdbc:mysql://localhost:3306/adopetz";
                    String user = "root";
                    String password = "root";

                    Connection connection = null;
                    PreparedStatement checkStmt = null;
                    PreparedStatement deleteStmt = null;

                    try {
                        // Conexão com o banco de dados
                        connection = DriverManager.getConnection(url, user, password);

                        // Verificar se o anúncio existe
                        String checkSQL = "SELECT * FROM adocao WHERE id = ? AND anunciante_nome = ?";
                        checkStmt = connection.prepareStatement(checkSQL);
                        checkStmt.setInt(1, Integer.parseInt(anuncioId));
                        checkStmt.setString(2, anuncianteNome);

                        ResultSet resultSet = checkStmt.executeQuery();

                        if (resultSet.next()) {
                            // Excluir o registro da tabela
                            String deleteSQL = "DELETE FROM adocao WHERE id = ? AND anunciante_nome = ?";
                            deleteStmt = connection.prepareStatement(deleteSQL);
                            deleteStmt.setInt(1, Integer.parseInt(anuncioId));
                            deleteStmt.setString(2, anuncianteNome);
                            deleteStmt.executeUpdate();

                            out.println("<p style='color: green;'>Anúncio excluído com sucesso!</p>");
                        } else {
                            out.println("<p style='color: red;'>Nenhum anúncio encontrado com os dados fornecidos.</p>");
                        }

                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<p style='color: red;'>Erro ao excluir o anúncio: " + e.getMessage() + "</p>");
                    } finally {
                        if (checkStmt != null) checkStmt.close();
                        if (deleteStmt != null) deleteStmt.close();
                        if (connection != null) connection.close();
                    }
                }
            %>
        </div>
    <a href="<%= "super_admin".equals(request.getSession().getAttribute("tipo")) ? "admin-dashboard.jsp" : "dashboardadmincomum.jsp" %>" class="button">Voltar ao Painel</a>
    </div>
</body>
</html>
