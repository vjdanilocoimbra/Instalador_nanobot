# Nanobot - Instalador

> ⚠️ **Este repositório é apenas um INSTALADOR, não é o projeto Nanobot.**
> O projeto original é de [HKUDS/nanobot](https://github.com/HKUDS/nanobot). Aqui você encontra apenas scripts que automatizam a instalação do Nanobot + dependências (Python, Node.js, FFmpeg) em 1 clique no Windows.

---

## Objetivo

Facilitar o uso da IA **Nanobot** para qualquer pessoa, mesmo sem conhecimento técnico. Automatiza a instalação de dependências e prepara o ambiente. Ideal para quem não quer configurar tudo manualmente.

---

## ⬇ Download

### [Baixar Nanobot Instalador (.zip)](https://github.com/vjdanilocoimbra/Instalador_nanobot/releases/latest/download/Nanobot_Instalador.zip)

> Ou acesse a aba **Releases** no topo desta página.

---

## Como instalar

1. Baixe o `.zip` no link acima
2. **Botão direito no .zip → Propriedades → marcar "Desbloquear" → OK**
   *(evita que o Windows trave os arquivos por terem vindo da internet)*
3. Extraia o .zip (botão direito → "Extrair tudo")
4. Entre na pasta extraída e clique duplo em **`Instalar_Nanobot.exe`**
5. Se aparecer tela azul do Windows: clique em **"Mais informações"** → **"Executar assim mesmo"**
6. Clique **"Sim"** no aviso de administrador
7. Clique em **"INSTALAR REQUISITOS"**
8. Aguarde 5 a 15 minutos. Quando terminar, o Nanobot abre sozinho.

Instruções completas (incluindo como configurar a chave da OpenAI) estão no arquivo `_LEIA-PRIMEIRO.txt` dentro do zip.

---

## Se o antivírus bloquear o `.exe`

Use o **`Instalar_Nanobot.bat`** (botão direito → "Executar como administrador"). Faz a mesma coisa.

É comum antivírus acharem instaladores "suspeitos" porque eles pedem permissão de admin e baixam arquivos. Não é vírus — o código é todo aberto neste repositório.

---

## Custo de uso

O Nanobot usa a API da OpenAI (gpt-4o-mini): aproximadamente **R$ 0,006 por mensagem**.
Com US$ 5 (~R$ 28) você tem 3 a 6 meses de uso.

---

## Créditos

### Projeto original (Nanobot)
- **Repositório oficial:** [github.com/HKUDS/nanobot](https://github.com/HKUDS/nanobot)
- **Mantenedor:** HKUDS (Hong Kong University of Science and Technology) / xubinren
- **Licença:** MIT
- Todo o funcionamento da IA, processamento e lógica conversacional é do projeto original. Todo o crédito técnico vai para os autores originais.

### Este repositório (Instalador)
- **Autor dos scripts de instalação:** [@vjdanilocoimbra](https://www.instagram.com/vjdanilocoimbra/)
- Contém apenas: scripts `.bat`, `.ps1` e `.exe` que instalam o Nanobot automaticamente via `pip install nanobot-ai`, baixam dependências (Python, Node.js, FFmpeg) e criam atalhos no Windows.
- **Não redistribui código do Nanobot**, não modifica o projeto original, e não reivindica autoria dele.

---

## Licença

Os scripts deste repositório são distribuídos sob a **Licença MIT** (veja o arquivo [LICENSE](LICENSE)), a mesma licença do projeto Nanobot original.

O Nanobot em si mantém sua própria licença: [LICENSE do HKUDS/nanobot](https://github.com/HKUDS/nanobot/blob/main/LICENSE).

---

## Suporte

- **Problemas com este instalador:** abra uma [Issue](https://github.com/vjdanilocoimbra/Instalador_nanobot/issues) ou chame no Instagram [@vjdanilocoimbra](https://www.instagram.com/vjdanilocoimbra/)
- **Problemas com o Nanobot em si:** reporte no [repositório oficial do Nanobot](https://github.com/HKUDS/nanobot/issues)
