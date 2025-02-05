<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null || !"admin".equals(userSession.getAttribute("tipo"))) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <link rel="stylesheet" href="../css/admin-dashboard.css">
    <title>Painel do Administrador</title>
</head>
<body>
    <header>
        <img id="logo" src="../Images/Adopt 200x200.png" alt="Logo da Empresa"> 
    </header>
    <main class="container">
        <h1>Painel do Administrador</h1>
      <section>
            <h2>Comandos para Clientes</h2>
            <div class="button-container">
                <a href="cadastro.jsp" class="button">Cadastrar Cliente</a>
                <a href="excluir_clientes.jsp" class="button">Excluir Cliente</a>
                <a href="redefinir_dados.jsp" class="button">Alterar Cliente</a>
                <a href="buscar_dados.jsp" class="button">Puxar Dados de um Cliente</a>
                <a href="banir.jsp" class="button">Banir Usuário</a>
                <a href="dados_banidos.jsp" class="button">Puxar Dados Usuarios Banidos</a>
            </div>
        </section>

        <!-- Comandos para Administradores -->
      

        <!-- Comandos Gerais -->
        <section>
            <h2>Comandos Gerais</h2>
            <div class="button-container">
                <a href="dados-adocao.jsp" class="button">Puxar Dados de um Anúncio</a>
                
                <a href="deletar_anuncio.jsp" class="button">Deletar Anúncio</a>
                
            </div>
        </section>  <div class="button-container">

        </div>
        <a href="logout.jsp" class="back-link">Finalizar Sessão</a>
    </main>
</body>
</html>
