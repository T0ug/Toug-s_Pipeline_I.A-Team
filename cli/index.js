#!/usr/bin/env node

import { initCommand } from "./commands/init.js";
import { doctorCommand } from "./commands/doctor.js";
import { upgradeCommand } from "./commands/upgrade.js";

const [, , command, ...args] = process.argv;

function printHelp() {
    console.log(`Toug's Pipeline I.A

CLI auxiliar para instalar e validar a pipeline Codex-native em um projeto real.

Comandos:
  toug-pipeline init [--with-docs]
    Instala AGENTS.md, .agents/ e .github/ no diretorio atual.

  toug-pipeline doctor
    Verifica se a instalacao da pipeline no diretorio atual esta valida.

  toug-pipeline upgrade
    Atualiza AGENTS.md, .agents/ e .github/ no diretorio atual.

Opcoes:
  --with-docs   Depois do init, cria docs/project, docs/tasks, docs/releases e docs/archive.
  --force       Permite sobrescrever arquivos da pipeline durante init/upgrade.
  --help        Mostra esta ajuda.
`);
}

try {
    switch (command) {
        case "init":
            await initCommand(args);
            break;
        case "doctor":
            await doctorCommand(args);
            break;
        case "upgrade":
            await upgradeCommand(args);
            break;
        case undefined:
        case "help":
        case "--help":
        case "-h":
            printHelp();
            break;
        default:
            console.error(`Comando desconhecido: ${command}`);
            printHelp();
            process.exit(1);
    }
} catch (error) {
    console.error(error.message);
    process.exit(1);
}
