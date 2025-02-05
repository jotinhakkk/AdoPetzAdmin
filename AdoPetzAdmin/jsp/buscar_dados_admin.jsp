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
    <title>Buscar Administradores</title>
    <style>
        .password-field {
            display: flex;
            align-items: center;
        }
        .password-field input {
            border: none;
            background: transparent;
            font-size: 1em;
            margin-right: 2px;
        }
        .password-field button {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Lista de Administradores</h1>
        
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Digite para pesquisar...">
        
        <table id="clientsTable">
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>CEP</th>
                    <th>CPF</th>
                    <th>Email</th>
                    <th>Senha</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection connection = null;
                    ResultSet resultSet = null;
                    PreparedStatement stmt = null;
                    String url = "jdbc:mysql://localhost:3306/adopetz"; 
                    String user = "root"; 
                    String password = "root"; 

                    try {
                        // Estabelece a conexão com o banco de dados
                        Class.forName("com.mysql.cj.jdbc.Driver"); 
                        connection = DriverManager.getConnection(url, user, password);

                        if (connection != null) {
                            // Ajuste a consulta SQL para refletir a estrutura correta da tabela administrador
                            String sql = "SELECT nome, cep, cpf, email, senha FROM administrador";
                            stmt = connection.prepareStatement(sql);
                            resultSet = stmt.executeQuery();

                            if (!resultSet.isBeforeFirst()) {
                                // Nenhum dado encontrado
                                out.println("<tr><td colspan='5'>Nenhum dado encontrado.</td></tr>");
                            } else {
                                while (resultSet.next()) {
                                    String nome = resultSet.getString("nome");
                                    String cep = resultSet.getString("cep");
                                    String cpf = resultSet.getString("cpf");
                                    String email = resultSet.getString("email");
                                    String senha = resultSet.getString("senha");
                %>
                <tr>
                    <td><%= nome %></td>
                    <td><%= cep %></td>
                    <td><%= cpf %></td>
                    <td><%= email %></td>
                    <td>
                        <div class="password-field">
                            <input type="password" value="<%= senha %>" readonly>
                            <button onclick="togglePassword(this)">👁</button>
                        </div>
                    </td>
                </tr>
                <% 
                                }
                            }
                        } else {
                            out.println("<tr><td colspan='5'>Erro na conexão com o banco de dados.</td></tr>");
                        }
                    } catch (ClassNotFoundException e) {
                        out.println("<tr><td colspan='5'>Driver do banco de dados não encontrado.</td></tr>");
                        e.printStackTrace();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='5'>Erro ao executar a consulta SQL: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        if (resultSet != null) {
                            try {
                                resultSet.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        if (stmt != null) {
                            try {
                                stmt.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        if (connection != null) {
                            try {
                                connection.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </tbody>
        </table>
        <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
    </div>

    <script>
        function filterTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("clientsTable");
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

        function togglePassword(button) {
            var input = button.previousElementSibling;
            if (input.type === "password") {
                input.type = "text";
                button.textContent = "👀"; // Icone de "olho aberto"
            } else {
                input.type = "password";
                button.textContent = "👁"; // Icone de "olho fechado"
            }
        }
    </script>
</body>
</html>
