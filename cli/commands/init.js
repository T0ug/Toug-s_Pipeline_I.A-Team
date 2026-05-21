import fs from "fs";
import path from "path";
import { spawnSync } from "child_process";
import { fileURLToPath } from "url";

const PIPELINE_ITEMS = ["AGENTS.md", ".agents", ".github"];

export function getPackageRoot() {
    const filename = fileURLToPath(import.meta.url);
    return path.resolve(path.dirname(filename), "../..");
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

function copyPipelineItem(sourceRoot, targetRoot, item, force) {
    const source = path.join(sourceRoot, item);
    const target = path.join(targetRoot, item);

    if (!fs.existsSync(source)) {
        throw new Error(`Arquivo obrigatorio nao encontrado no pacote: ${item}`);
    }

    assertInsideRoot(targetRoot, target);

    if (fs.existsSync(target)) {
        if (!force) {
            throw new Error(`Ja existe ${item}. Use --force para atualizar arquivos da pipeline.`);
        }
        fs.rmSync(target, { recursive: true, force: true });
    }

    fs.cpSync(source, target, { recursive: true });
}

function findInstallConflicts(targetRoot) {
    return PIPELINE_ITEMS.filter((item) => fs.existsSync(path.join(targetRoot, item)));
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
    const targetRoot = options.targetRoot ?? process.cwd();
    const force = options.force ?? false;
    const withDocs = options.withDocs ?? false;
    const allowExisting = options.allowExisting ?? false;
    const quiet = options.quiet ?? false;
    const conflicts = findInstallConflicts(targetRoot);
    const allPipelineItemsExist = conflicts.length === PIPELINE_ITEMS.length;

    if (conflicts.length > 0 && !force && !(allowExisting && allPipelineItemsExist)) {
        throw new Error(`Ja existem arquivos da pipeline: ${conflicts.join(", ")}. Use --force para atualizar.`);
    }

    for (const item of PIPELINE_ITEMS) {
        if (allowExisting && !force && fs.existsSync(path.join(targetRoot, item))) {
            if (!quiet) {
                console.log(`Existe: ${item}`);
            }
            continue;
        }

        copyPipelineItem(sourceRoot, targetRoot, item, force);
        if (!quiet) {
            console.log(`Instalado: ${item}`);
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
        withDocs,
        allowExisting: withDocs
    });
}
