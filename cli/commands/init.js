import fs from "fs";
import path from "path";
import { spawnSync } from "child_process";
import { fileURLToPath } from "url";

const PIPELINE_ITEMS = ["AGENTS.md", ".agents", ".github"];

export function getPackageRoot() {
    const filename = fileURLToPath(import.meta.url);
    return path.resolve(path.dirname(filename), "../..");
}

function looksLikeMojibake(value) {
    return /[ÃÂ�]/.test(value);
}

function decodeMojibake(value) {
    if (!looksLikeMojibake(value)) {
        return value;
    }

    try {
        return Buffer.from(value, "latin1").toString("utf8");
    } catch {
        return value;
    }
}

export function resolveProjectRoot(candidate = process.cwd()) {
    const raw = path.resolve(candidate);
    const decoded = path.resolve(decodeMojibake(raw));

    if (decoded !== raw && fs.existsSync(decoded)) {
        return decoded;
    }

    return raw;
}

function hasFlag(args, flag) {
    return args.includes(flag);
}

function assertInsideRoot(root, target) {
    const relative = path.relative(root, target);
    if (relative.startsWith("..") || path.isAbsolute(relative)) {
        throw new Error(`Caminho fora do projeto alvo: ${target}`);
    }
}

function copyDirectory(source, target, force) {
    fs.mkdirSync(target, { recursive: true });

    for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
        const sourceEntry = path.join(source, entry.name);
        const targetEntry = path.join(target, entry.name);

        if (entry.isDirectory()) {
            copyDirectory(sourceEntry, targetEntry, force);
            continue;
        }

        if (entry.isFile()) {
            if (force || !fs.existsSync(targetEntry)) {
                fs.copyFileSync(sourceEntry, targetEntry);
            }
        }
    }
}

function copyPipelineItem(sourceRoot, targetRoot, item, force) {
    const source = path.join(sourceRoot, item);
    const target = path.join(targetRoot, item);

    if (!fs.existsSync(source)) {
        throw new Error(`Arquivo obrigatorio nao encontrado no pacote: ${item}`);
    }

    assertInsideRoot(targetRoot, target);

    if (fs.existsSync(target) && !force) {
        const sourceStats = fs.statSync(source);
        const targetStats = fs.statSync(target);

        if (sourceStats.isDirectory() && targetStats.isDirectory()) {
            copyDirectory(source, target, false);
            return "merged";
        }

        return "exists";
    }

    const sourceStats = fs.statSync(source);

    if (sourceStats.isDirectory()) {
        copyDirectory(source, target, true);
    } else {
        fs.copyFileSync(source, target);
    }

    return force ? "updated" : "installed";
}

function runInitProject(targetRoot) {
    const script = path.join(targetRoot, ".agents", "scripts", "init_project.ps1");

    if (!fs.existsSync(script)) {
        throw new Error("Nao foi possivel criar docs: .agents/scripts/init_project.ps1 nao encontrado.");
    }

    const candidates = process.platform === "win32"
        ? ["powershell.exe", "pwsh.exe"]
        : ["pwsh"];

    let lastResult = null;

    for (const command of candidates) {
        const result = spawnSync(command, [
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-File",
            script,
            "-Root",
            targetRoot
        ], {
            encoding: "utf8",
            stdio: "inherit"
        });

        lastResult = result;

        if (!result.error && result.status === 0) {
            return;
        }

        if (result.error?.code !== "ENOENT") {
            break;
        }
    }

    const detail = lastResult?.error?.message ?? `codigo ${lastResult?.status ?? "desconhecido"}`;
    throw new Error(`Falha ao criar docs do projeto: ${detail}`);
}

export function installPipeline(options = {}) {
    const sourceRoot = options.sourceRoot ?? getPackageRoot();
    const targetRoot = resolveProjectRoot(options.targetRoot ?? process.cwd());
    const force = options.force ?? false;
    const withDocs = options.withDocs ?? false;
    const quiet = options.quiet ?? false;

    for (const item of PIPELINE_ITEMS) {
        const result = copyPipelineItem(sourceRoot, targetRoot, item, force);
        if (!quiet) {
            const label = {
                exists: "Existe",
                installed: "Instalado",
                merged: "Preenchido",
                updated: "Atualizado"
            }[result] ?? "Instalado";

            console.log(`${label}: ${item}`);
        }
    }

    if (withDocs) {
        runInitProject(targetRoot);
    }

    if (!quiet) {
        console.log("Pipeline Codex-native instalada.");
        console.log("No Codex, abra o projeto e pergunte: qual o estado atual da pipeline?");
    }
}

export async function initCommand(args = []) {
    const withDocs = hasFlag(args, "--with-docs");

    installPipeline({
        force: hasFlag(args, "--force"),
        withDocs
    });
}
