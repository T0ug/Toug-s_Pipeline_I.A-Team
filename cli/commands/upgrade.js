import { initCommand, resolveProjectRoot } from "./init.js";
import fs from "fs";
import path from "path";

const PIPELINE_ITEMS = ["AGENTS.md", ".agents", ".github"];

function timestamp() {
    return new Date().toISOString().replace(/[-:]/g, "").replace(/\..+/, "").replace("T", "-");
}

function copyRecursive(source, target) {
    const stats = fs.statSync(source);

    if (stats.isDirectory()) {
        fs.mkdirSync(target, { recursive: true });

        for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
            copyRecursive(path.join(source, entry.name), path.join(target, entry.name));
        }
        return;
    }

    if (stats.isFile()) {
        const parent = path.dirname(target);
        fs.mkdirSync(parent, { recursive: true });
        fs.copyFileSync(source, target);
    }
}

export async function upgradeCommand(args = []) {
    const nextArgs = args.includes("--force") ? args : [...args, "--force"];
    const root = resolveProjectRoot();
    const existingItems = PIPELINE_ITEMS.filter((item) => fs.existsSync(path.join(root, item)));

    if (existingItems.length > 0) {
        const backupRoot = path.join(root, `.pipeline-upgrade-backup-${timestamp()}`);
        fs.mkdirSync(backupRoot, { recursive: true });

        for (const item of existingItems) {
            copyRecursive(path.join(root, item), path.join(backupRoot, item));
        }

        console.log(`Backup criado em: ${backupRoot}`);
    }

    console.log("Atualizando arquivos da pipeline Codex-native...");
    await initCommand(nextArgs);
    console.log("Upgrade concluido.");
}
