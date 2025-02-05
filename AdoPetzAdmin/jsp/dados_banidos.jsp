<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/buscar_dados.css">
    <title>Lista de Usuários Banidos</title>
</head>
<body>
    <div class="container">
        <h1>Lista de Usuários Banidos</h1>
        
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Digite para pesquisar...">
        
        <table id="bannedUsersTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>CPF</th>
                    <th>Telefone</th>
                    <th>CEP</th>
                    <th>Email</th>
                    <th>Estado</th>
                    <th>Data de Banimento</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    String url = "jdbc:mysql://localhost:3306/adopetz"; 
                    String user = "root";       
                    String password = "root"; 
                    try (Connection connection = DriverManager.getConnection(url, user, password)) {
                        if (connection != null) {
                            String sql = "SELECT id, nome, cpf, telefone, cep, email, estado, data_banimento FROM usuarios_banidos";
                            try (PreparedStatement stmt = connection.prepareStatement(sql);
                                 ResultSet resultSet = stmt.executeQuery()) {

                                if (!resultSet.isBeforeFirst()) {
                                    out.println("<tr><td colspan='8'>Nenhum dado encontrado.</td></tr>");
                                } else {
                                    while (resultSet.next()) {
                                        int id = resultSet.getInt("id");
                                        String nome = resultSet.getString("nome");
                                        String cpf = resultSet.getString("cpf");
                                        String telefone = resultSet.getString("telefone");
                                        String cep = resultSet.getString("cep");
                                        String email = resultSet.getString("email");
                                        String estado = resultSet.getString("estado");
                                        String dataBanimento = resultSet.getString("data_banimento");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= nome %></td>
                    <td><%= cpf %></td>
                    <td><%= telefone %></td>
                    <td><%= cep %></td>
                    <td><%= email %></td>
                    <td><%= estado %></td>
                    <td><%= dataBanimento %></td>
                </tr>
                <% 
                                    }
                                }
                            }
                        } else {
                            out.println("<tr><td colspan='8'>Erro na conexão com o banco de dados.</td></tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='8'>Erro ao executar a consulta SQL: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
       
        <script>
            var tipoUsuario = '<%= userSession.getAttribute("tipo") %>';
            if (tipoUsuario === 'super_admin') {
                document.write('<a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>');
            } else {
                document.write('<a href="dashboardadmincomum.jsp" class="button">Voltar ao Painel de Controle</a>');
            }
        </script>
    </div>

    <script>
        function filterTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("bannedUsersTable");
            tr = table.getElementsByTagName("tr");

            for (i = 1; i < tr.length; i++) {
                tr[i].style.display = "none";
                td = tr[i].getElementsByTagName("td");
                for (var j = 0; j < td.length; j++) {
                    if (td[j]) {
                        txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                    }
                }
            }
        }
    </script>
</body>
</html>
