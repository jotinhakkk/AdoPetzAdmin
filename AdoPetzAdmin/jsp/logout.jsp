<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession Session = request.getSession(false);
    if (Session != null) {
        Session.invalidate(); // Invalida a sessão do usuário
    }
    response.sendRedirect("../CadastroAdministrador/login.html"); // Redireciona para a página de login
%>
