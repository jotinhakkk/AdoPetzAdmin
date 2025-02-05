<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
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
    <title>Lista de Adoções</title>
</head>
<body>
    <div class="container">
        <h1>Lista de Adoções</h1>
        
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Digite para pesquisar...">
        
        <table id="adoptionTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome do Animal</th>
                    <th>Raça</th>
                    <th>Status</th>
                    <th>Adotante</th>
                    <th>CPF do Adotante</th>
                    <th>Anunciante</th>
                    <th>CPF do Anunciante</th>
                    <th>Data de Adoção</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String url = "jdbc:mysql://localhost:3306/adopetz";
                    String user = "root";
                    String password = "root";

                    try (Connection connection = DriverManager.getConnection(url, user, password)) {
                        if (connection != null) {
                            String sql = "SELECT id, animal_nome, animal_raca, Status, adotante_nome, adotante_cpf, anunciante_nome, anunciante_cpf, data_adocao FROM adocao";
                            try (PreparedStatement stmt = connection.prepareStatement(sql);
                                ResultSet resultSet = stmt.executeQuery()) {

                                if (!resultSet.isBeforeFirst()) {
                                    out.println("<tr><td colspan='9'>Nenhum dado encontrado.</td></tr>");
                                } else {
                                    while (resultSet.next()) {
                                        int id = resultSet.getInt("id");
                                        String animalNome = resultSet.getString("animal_nome");
                                        String animalRaca = resultSet.getString("animal_raca");
                                        String status = resultSet.getString("Status");
                                        String adotanteNome = resultSet.getString("adotante_nome");
                                        String adotanteCpf = resultSet.getString("adotante_cpf");
                                        String anuncianteNome = resultSet.getString("anunciante_nome");
                                        String anuncianteCpf = resultSet.getString("anunciante_cpf");
                                        String dataAdocao = resultSet.getString("data_adocao");
                %>
                <tr>
                    <td><%= id %></td>
                    <td><%= animalNome %></td>
                    <td><%= animalRaca %></td>
                    <td><%= status %></td>
                    <td><%= adotanteNome %></td>
                    <td><%= adotanteCpf %></td>
                    <td><%= anuncianteNome %></td>
                    <td><%= anuncianteCpf %></td>
                    <td><%= dataAdocao %></td>
                </tr>
                <% 
                                    }
                                }
                            }
                        } else {
                            out.println("<tr><td colspan='9'>Erro na conexão com o banco de dados.</td></tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='9'>Erro ao executar a consulta SQL: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
        <a href="<%= "super_admin".equals(Session.getAttribute("tipo")) ? "admin-dashboard.jsp" : "dashboardadmincomum.jsp" %>" class="button">Voltar ao Painel de Controle</a>
    </div>

    <script>
        function filterTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("adoptionTable");
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
