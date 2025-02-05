<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("email") == null || !"super_admin".equals(userSession.getAttribute("tipo"))) {
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
    <title>Painel do Super Administrador</title>
</head>
<body>
    <header>
        <div class="header-container">
            <img id="logo" src="../Images/Adopt 200x200.png" alt="Logo da Empresa">
            <h1>Painel do Super Administrador</h1>
        </div>
    </header>
    <main class="container">
        <h1>Opções Disponíveis</h1>

        <!-- Comandos para Clientes -->
        <section>
            <h2>Comandos para Clientes</h2>
            <div class="button-container">
                <a href="cadastro.jsp" class="button">Cadastrar Usuarios</a>
                <a href="excluir_clientes.jsp" class="button">Excluir Usuarios</a>
                <a href="redefinir_dados.jsp" class="button">Alterar Ususarios</a>
                <a href="buscar_dados.jsp" class="button">Puxar Dados de um Usuario</a>
                <a href="banir.jsp" class="button">Banir Usuário</a>
                <a href="dados_banidos.jsp" class="button">Puxar Dados Usuarios Banidos</a>
            </div>
        </section>

        <!-- Comandos para Administradores -->
        <section>
            <h2>Comandos para Administradores</h2>
            <div class="button-container">
                <a href="cadastro-admin.jsp" class="button">Cadastrar Administrador</a>
                <a href="excluir_admin.jsp" class="button">Excluir Administrador</a>
                <a href="redefinir-dados-admin.jsp" class="button">Alterar Administrador</a>
                <a href="buscar_dados_admin.jsp" class="button">Puxar Dados de Administradores</a>
            </div>
        </section>

        <!-- Comandos Gerais -->
        <section>
            <h2>Comandos Gerais</h2>
            <div class="button-container">
                <a href="dados-adocao.jsp" class="button">Puxar Dados de um Anúncio</a>
                <a href="deletar_anuncio.jsp" class="button">Deletar Anúncio</a>
            </div>
        </section>

        <!-- Finalizar Sessão -->
        <a href="logout.jsp" class="back-link">Finalizar Sessão</a>
    </main>
</body>
</html>




