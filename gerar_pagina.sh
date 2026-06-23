#!/bin/bash

# Verifica se o arquivo alunos.txt existe
if [ ! -f alunos.txt ]; then
    echo "Erro: O arquivo alunos.txt não foi encontrado!"
    exit 1
fi

# Coleta de informações do sistema de forma otimizada
HOSTNAME=$(hostname)
KERNEL=$(uname -r)

# Busca o nome amigável da distro sem carregar múltiplos arquivos
if [ -f /etc/os-release ]; then
    . /etc/os-release
    LINUX_VERSION=$PRETTY_NAME
else
    LINUX_VERSION="Linux Desconhecido"
fi

# Trata a leitura da CPU (evita quebra se lscpu omitir o campo ou não estiver instalado)
CPU=$(lscpu 2>/dev/null | grep -m1 "Model name" | cut -d: -f2 | sed -e 's/^[[:space:]]*//')
[ -z "$CPU" ] && CPU=$(lscpu 2>/dev/null | grep -m1 "Vendor ID" | cut -d: -f2 | sed -e 's/^[[:space:]]*//')
[ -z "$CPU" ] && CPU="Não identificada (Ambiente Containerizado)"

MEMORIA=$(free -h 2>/dev/null | grep Mem | awk '{print $2 " total (Usado: " $3 " / Livre: " $4 ")"}')
[ -z "$MEMORIA" ] && MEMORIA="Não foi possível ler a memória"

DISCO=$(df -h / | tail -n 1 | awk '{print $2 " total (Usado: " $3 " / Livre: " $4 ")"}')

# Início da geração do arquivo HTML
cat <<EOF > alunos.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistemas Operacionais - UNIFEBE</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-900 text-slate-100 min-h-screen font-sans antialiased selection:bg-cyan-500 selection:text-slate-900">

    <div class="max-w-5xl mx-auto px-4 py-12">
        
        <header class="text-center mb-12 border-b border-slate-800 pb-8">
            <span class="text-cyan-400 font-bold tracking-widest text-xs uppercase bg-cyan-950/50 px-3 py-1.5 rounded-full border border-cyan-800/30">
                Sistemas de Informação
            </span>
            <h1 class="text-4xl font-extrabold text-white mt-4 tracking-tight sm:text-5xl">
                UNIFEBE
            </h1>
            <p class="mt-2 text-lg text-slate-400 font-medium">
                Laboratório de Sistemas Operacionais
            </p>
        </header>

        <main class="mb-16">
            <div class="flex items-center space-x-3 mb-6">
                <h2 class="text-2xl font-bold text-white tracking-tight">Lista de Alunos</h2>
                <span class="bg-slate-800 text-slate-300 text-xs font-semibold px-2.5 py-0.5 rounded-full border border-slate-700">
                    Turma Ativa
                </span>
            </div>
            
            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
EOF

# Loop para iterar sobre os alunos e renderizá-los em Cards modernos
while IFS= read -r aluno || [ -n "$aluno" ]; do
    # Ignora linhas vazias caso existam no arquivo
    [ -z "$aluno" ] && continue
    
    cat <<EOF >> alunos.html
                <div class="bg-slate-800/50 border border-slate-700/50 rounded-xl p-5 flex flex-col items-center justify-center text-center transition-all duration-300 hover:border-cyan-500/40 hover:bg-slate-800 group hover:shadow-lg hover:shadow-cyan-500/5">
                    <div class="w-16 h-16 bg-slate-700/40 rounded-full flex items-center justify-center border border-slate-600/30 group-hover:border-cyan-500/30 transition-colors">
                        <img class="w-10 h-10 opacity-80 group-hover:opacity-100 transition-opacity" src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Avatar do Aluno $aluno">
                    </div>
                    <p class="mt-4 font-medium text-slate-200 group-hover:text-white transition-colors truncate w-full px-1">
                        $aluno
                    </p>
                </div>
EOF
done < alunos.txt

# Seção: Informações do Sistema
cat <<EOF >> alunos.html
            </div>
        </main>

        <section class="bg-slate-800/40 border border-slate-700/40 rounded-2xl p-6 backdrop-blur-sm">
            <div class="flex items-center space-x-3 mb-6 border-b border-slate-700/50 pb-4">
                <svg class="w-6 h-6 text-cyan-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 5h10a2 2 0 012 2v10a2 2 0 01-2 2H7a2 2 0 01-2-2V7a2 2 0 012-2z"></path>
                </svg>
                <h2 class="text-xl font-bold text-white tracking-tight">Status do Host & Infraestrutura</h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Hostname</span>
                    <span class="mt-1 font-mono text-cyan-400">$HOSTNAME</span>
                </div>
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Versão do Kernel</span>
                    <span class="mt-1 font-mono text-slate-300">$KERNEL</span>
                </div>
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800 md:col-span-2">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Distribuição Linux</span>
                    <span class="mt-1 font-medium text-slate-200">$LINUX_VERSION</span>
                </div>
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800 md:col-span-2">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Processador (CPU)</span>
                    <span class="mt-1 text-slate-300 font-medium">$CPU</span>
                </div>
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Memória RAM</span>
                    <span class="mt-1 font-mono text-emerald-400">$MEMORIA</span>
                </div>
                <div class="flex flex-col p-3 bg-slate-900/40 rounded-lg border border-slate-800">
                    <span class="text-xs text-slate-500 font-semibold uppercase tracking-wider">Armazenamento (Disco /)</span>
                    <span class="mt-1 font-mono text-amber-400">$DISCO</span>
                </div>
            </div>
        </section>

        <footer class="text-center mt-12 text-xs text-slate-500">
            Ambiente de avaliação gerado automaticamente via Shell Script no Docker.
        </footer>
    </div>

</body>
</html>
EOF

echo "Arquivo alunos.html gerado com sucesso!"