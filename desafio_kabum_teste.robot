*** Settings ***
Documentation    Suíte responsável por adicionar um notebook ao carrinho da kabum
Resource         desafio_kabum_resources.robot
Test Setup       Abrir o navegador
Test Teardown    Fechar o navegador

*** Test Cases ***
Test Case 01 - Adicionar Produto na categoria Notebook
    [Documentation]  Esse teste verifica se está inserindo o primeiro produto da categoria notebook no carrinho 
    ...              e valida se o produto foi adiconado no carrinho com a garantia de 24 meses
    [Tags]           compra_produto  carrinho
    Acessar o site www.kabum.com.br e verificar o titulo da home
    Aceitar Política de Cookies
    Realizar busca pela categoria "notebook"
    Verificar que a página é "notebook"
    Selecionar o primeiro produto da lista da categoria "notebook"
    Digitar CEP e validar valores de frete
    Validar as opções de frete apresentadas
    Fechar tela de opções de frete
    Adicionar produto ao carrinho
    Selecionar garantia estendida    
    Ir para o carrinho
    Validar produto no carrinho
