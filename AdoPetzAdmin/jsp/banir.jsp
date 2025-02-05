<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Banir Usuário</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/excluir.css">
</head>
<body>
    <div class="container">
        <h1>Banir Usuário</h1>
        <form action="" method="post">
            <label for="email">Digite o e-mail do usuário:</label>
            <input type="email" id="email" name="email" placeholder="Digite o e-mail" required>
            <input type="submit" value="Banir">
        </form>
        <a href="<%= "super_admin".equals(request.getSession().getAttribute("tipo")) ? "admin-dashboard.jsp" : "dashboardadmincomum.jsp" %>" class="button">Voltar ao Painel</a>
        <div class="result-message">
            <%
                String email = request.getParameter("email");
                if (email != null && !email.isEmpty()) {
                    String url = "jdbc:mysql://localhost:3306/adopetz";
                    String user = "root";
                    String password = "root";

                    Connection connection = null;
                    PreparedStatement checkUserStmt = null;
                    PreparedStatement moveUserStmt = null;
                    PreparedStatement deleteMessagesStmt = null;
                    PreparedStatement deleteChatsStmt = null;
                    PreparedStatement deleteAdocaoStmt = null;
                    PreparedStatement deleteAnimaisStmt = null;
                    PreparedStatement deleteAvaliacaoStmt = null;
                    PreparedStatement deleteUserStmt = null;

                    try {
                        connection = DriverManager.getConnection(url, user, password);

                        // Verificar se o usuário existe
                        String checkUserSQL = "SELECT * FROM usuario WHERE email = ?";
                        checkUserStmt = connection.prepareStatement(checkUserSQL);
                        checkUserStmt.setString(1, email);
                        ResultSet rs = checkUserStmt.executeQuery();

                        if (rs.next()) {
                            // Mover o usuário para a tabela de usuários banidos
                            String moveUserSQL = "INSERT INTO usuarios_banidos (id, nome, cpf, telefone, cep, senha, email, estado) " +
                                                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                            moveUserStmt = connection.prepareStatement(moveUserSQL);
                            moveUserStmt.setInt(1, rs.getInt("id"));
                            moveUserStmt.setString(2, rs.getString("nome"));
                            moveUserStmt.setString(3, rs.getString("cpf"));
                            moveUserStmt.setString(4, rs.getString("telefone"));
                            moveUserStmt.setString(5, rs.getString("cep"));
                            moveUserStmt.setString(6, rs.getString("senha"));
                            moveUserStmt.setString(7, rs.getString("email"));
                            moveUserStmt.setString(8, rs.getString("estado"));
                            moveUserStmt.executeUpdate();

                            // Excluir as mensagens associadas aos chats do usuário
                            String deleteMessagesSQL = "DELETE FROM mensagens WHERE chat_id IN (SELECT id FROM chats WHERE adotante_id = ? OR anunciante_id = ?)";
                            deleteMessagesStmt = connection.prepareStatement(deleteMessagesSQL);
                            deleteMessagesStmt.setInt(1, rs.getInt("id"));
                            deleteMessagesStmt.setInt(2, rs.getInt("id"));
                            deleteMessagesStmt.executeUpdate();

                            // Excluir chats relacionados ao usuário
                            String deleteChatsSQL = "DELETE FROM chats WHERE adotante_id = ? OR anunciante_id = ?";
                            deleteChatsStmt = connection.prepareStatement(deleteChatsSQL);
                            deleteChatsStmt.setInt(1, rs.getInt("id"));
                            deleteChatsStmt.setInt(2, rs.getInt("id"));
                            deleteChatsStmt.executeUpdate();

                            // Excluir adoções relacionadas ao usuário
                            String deleteAdocaoSQL = "DELETE FROM adocao WHERE adotante_id = ? OR anunciante_id = ?";
                            deleteAdocaoStmt = connection.prepareStatement(deleteAdocaoSQL);
                            deleteAdocaoStmt.setInt(1, rs.getInt("id"));
                            deleteAdocaoStmt.setInt(2, rs.getInt("id"));
                            deleteAdocaoStmt.executeUpdate();

                            // Excluir avaliações relacionadas ao usuário
                            String deleteAvaliacaoSQL = "DELETE FROM avaliacao WHERE ClienteId = ? OR Adoid IN (SELECT id FROM adocao WHERE adotante_id = ? OR anunciante_id = ?)";
                            deleteAvaliacaoStmt = connection.prepareStatement(deleteAvaliacaoSQL);
                            deleteAvaliacaoStmt.setInt(1, rs.getInt("id"));
                            deleteAvaliacaoStmt.setInt(2, rs.getInt("id"));
                            deleteAvaliacaoStmt.setInt(3, rs.getInt("id"));
                            deleteAvaliacaoStmt.executeUpdate();

                            // Excluir animais relacionados ao usuário
                            String deleteAnimaisSQL = "DELETE FROM animais WHERE usuario_id = ?";
                            deleteAnimaisStmt = connection.prepareStatement(deleteAnimaisSQL);
                            deleteAnimaisStmt.setInt(1, rs.getInt("id"));
                            deleteAnimaisStmt.executeUpdate();

                            // Excluir o usuário da tabela original
                            String deleteUserSQL = "DELETE FROM usuario WHERE email = ?";
                            deleteUserStmt = connection.prepareStatement(deleteUserSQL);
                            deleteUserStmt.setString(1, email);
                            deleteUserStmt.executeUpdate();

                            out.println("<span class='success'>Usuário banido com sucesso!</span>");
                        } else {
                            out.println("<span class='error'>Usuário não encontrado.</span>");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<span class='error'>Erro ao processar a operação: " + e.getMessage() + "</span>");
                    } finally {
                        if (checkUserStmt != null) checkUserStmt.close();
                        if (moveUserStmt != null) moveUserStmt.close();
                        if (deleteMessagesStmt != null) deleteMessagesStmt.close();
                        if (deleteChatsStmt != null) deleteChatsStmt.close();
                        if (deleteAdocaoStmt != null) deleteAdocaoStmt.close();
                        if (deleteAvaliacaoStmt != null) deleteAvaliacaoStmt.close();
                        if (deleteAnimaisStmt != null) deleteAnimaisStmt.close();
                        if (deleteUserStmt != null) deleteUserStmt.close();
                        if (connection != null) connection.close();
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
