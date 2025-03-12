*** Settings ***
Documentation        Declaração das Librarys que serão implementadas no arquivo Resource
...                  1 - Library - https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
...                  2 - Collections - https://robotframework.org/robotframework/latest/libraries/Collections.html
Library              SeleniumLibrary
Library              Collections


*** Variables ***
${URL}                                https://www.kabum.com.br/    # URL do site a ser validado                                  
${Title_Home}                         KaBuM                        # Possíveis palavras que foram mapeadas no título da home                             
${INPUT_BUSCA}                        //input[@id='input-busca']   # Campo de busca da home-page                     
${CATEGORIA_BUSCA}                    notebook                     # Categoria a ser pesquisada no input-busca da home-page  
${Title_Notebook}                     Notebooks                    # Titulo a ser validado na Categoria notebook
${Primeiro_Produto_Notebook}          xpath=(//a[contains(@class,'sc-27518a44-4 kVoakD productLink')])[1] 
                                      # Elemento a ser clicado na categoria Notebooks, lógica feita utilizando o array da div's

${CEP}                                68950-000  # Utilizar CEP's válidos para o teste
${Frete}                              //div[@class='sc-15050c43-9 huiLLa'][contains(.,'Entrega Econômica R$ 129,54Chegará até: 08/04/2025Entrega Expressa R$ 199,16Chegará até: 01/04/2025')]
...                                   # Palavras chaves para verificar a existencia de frete para o CEP
...    
${AdicionarCarrinho}                  //button[@class='sc-8b813326-0 bLjOez'][contains(.,'COMPRAR')]
                                      # Botão para adicionar o produto no carrinho

${GARANTIA}                           xpath=(//input[@name='garantia'])[2]
                                      #  Valores de acordo com o  array - [1] - 12 meses / [2]- 24 meses 
                                      #  [3]- 36 meses [4] - Sem garantia

*** Keywords ***
Abrir o navegador
    [Documentation]    Abre o navegador Chrome e maximiza a janela.
    Open Browser                      browser=chrome  options=add_experimental_option("detach", True)
    Maximize Browser Window

Fechar o navegador
    [Documentation]    Captura uma captura de tela antes de fechar o navegador
    Capture Page Screenshot
    Close Browser
  
Acessar o site www.kabum.com.br e verificar o titulo da home
    [Documentation]    Acessa o site da Kabum e valida o título da página inicial de acordo com as palavras descritas nas variáveis
   
    Go To                            url=${URL}
    ${Titulo}                        Get Title
    Should Contain                   ${Titulo}     ${Title_Home}
    Wait Until Element Is Visible    locator=${INPUT_BUSCA}

Aceitar Política de Cookies
    [Documentation]    Aguarda e aceita a política de cookies, se presente.
    Wait Until Element Is Visible    id=onetrust-accept-btn-handler    timeout=05s
    Click Element                    id=onetrust-accept-btn-handler

Realizar busca pela categoria "notebook"
     [Documentation]    Realiza a busca pela categoria "notebook" no campo de pesquisa.
    Input Text                       //input[@id='input-busca']    ${CATEGORIA_BUSCA}
    Press Keys                       xpath=//input[@id="input-busca"]    ENTER

Verificar que a página é "notebook"
    [Documentation]    Verifica se o título da página corresponde à categoria "notebook".
    ${Titulo}   Get Title
    Should Contain    ${Titulo}    ${Title_Notebook}
    
Selecionar o primeiro produto da lista da categoria "notebook"
    [Documentation]    Seleciona o primeriro produto da categoria de acordo com o array setado nas variáveis.
    Wait Until Element Is Visible    locator=${Primeiro_Produto_Notebook}        timeout=05s 
    Scroll Element Into View         locator=${Primeiro_Produto_Notebook}
    Click Element                    locator=${Primeiro_Produto_Notebook}
                         
Digitar CEP e validar valores de frete   
    [Documentation]    Insere o CEP para ser calculado o frete
   
    Scroll Element Into View         xpath=//input[@id='inputCalcularFrete']
    Click Element                    xpath=//input[@id='inputCalcularFrete']
    Input Text                       //input[@id='inputCalcularFrete']    ${CEP}
    Scroll Element Into View         xpath=//button[contains(text(), 'OK')]
    Click Button                     xpath=//button[@id='botaoCalcularFrete']

Validar as opções de frete apresentadas
    [Documentation]                  Apresenta os nomes, valores e datas dos fretes apresentados em tela
   
    Wait Until Element Is Visible    id=listaOpcoesFrete    timeout=10s
    @{tipos_frete}    Create List
    @{valores_frete}    Create List
    @{datas_frete}    Create List

                                      # Extrai todos os elementos dos fretes apresentados em tela
    @{nomes_elements}    Get Webelements    xpath=//div[@id='listaOpcoesFrete']//span[contains(@class, 'ipyMwU')]
    @{precos_elements}   Get Webelements    xpath=//div[@id='listaOpcoesFrete']//span[contains(@class, 'etvZuo')]
    @{datas_elements}    Get Webelements    xpath=//div[@id='listaOpcoesFrete']//span[contains(@class, 'kNTQwJ')]
   
   # Armazena os valores nas listas
    FOR    ${nome}    IN    @{nomes_elements}
        ${nome_text}    Get Text    ${nome}
        Append To List    ${tipos_frete}    ${nome_text}
    END

    FOR    ${preco}    IN    @{precos_elements}
        ${preco_text}    Get Text    ${preco}
        Append To List    ${valores_frete}    ${preco_text}
    END

    FOR    ${data}    IN    @{datas_elements}
        ${data_text}    Get Text    ${data}
        Append To List    ${datas_frete}    ${data_text}
    END
Fechar tela de opções de frete
    [Documentation]    Fecha o pop-up de frete
    Press Keys    None    ESC

Adicionar produto ao carrinho    
    [Documentation]                 Adiciona o produto ao carrinho e faz uma captura de tela
    
    Click Element                    locator=${AdicionarCarrinho}
    Capture Page Screenshot 
Selecionar garantia estendida
    [Documentation]                     Espera o elemento garantia ser apresentado em tela e em seguida submete ação de 
    ...                                 A garantia está armazenada como varíavel desta forma pode ser validados 3 tipos de garantia
                
    Wait Until Page Contains Element    locator=${GARANTIA}      timeout=05s
    Click Element                       locator=${GARANTIA} 
                     
Ir para o carrinho
    [Documentation]                     Direcionamento a pagína do carrinho
   
    Click Button                        xpath=//button[.//span[contains(text(), 'Adicionar serviços')]]

Validar produto no carrinho
    [Documentation]                    Verifica se o título da página corresponde à categoria "Carrinho de Compras"
    ...                                Verifica se há o elemento input para fazer a validação da quantidade
    ...                                Verifica se existe um input com value='1', caso positvo há produtos no carrinho
    
    Wait Until Page Contains           text=Carrinho de Compras
    Wait Until Page Contains Element   xpath=//input    timeout=10s 
    ${elemento_existe}    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@value='1']
    Run Keyword If    ${elemento_existe}    Log To Console    Carrinho adicionado com sucesso
    ...    ELSE    Log To Console    Carrinho vazio
    Capture Page Screenshot