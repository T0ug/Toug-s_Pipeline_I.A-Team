import { initCommand } from "./init.js";
import fs from "fs";
import path from "path";

const PIPELINE_ITEMS = ["AGENTS.md", ".agents", ".github"];

function timestamp() {
    return new Date().toISOString().replace(/[-:]/g, "").replace(/\..+/, "").replace("T", "-");
}

export async function upgradeCommand(args = []) {
    const nextArgs = args.includes("--force") ? args : [...args, "--force"];
    const root = process.cwd();
    const existingItems = PIPELINE_ITEMS.filter((item) => fs.existsSync(path.join(root, item)));

    if (existingItems.length > 0) {
        const backupRoot = path.join(root, `.pipeline-upgrade-backup-${timestamp()}`);
        fs.mkdirSync(backupRoot, { recursive: true });

        for (const item of existingItems) {
            fs.cpSync(path.join(root, item), path.join(backupRoot, item), { recursive: true });
        }

        console.log(`Backup criado em: ${backupRoot}`);
    }

    console.log("Atualizando arquivos da pipeline Codex-native...");
    await initCommand(nextArgs);
    console.log("Upgrade concluido.");
}
