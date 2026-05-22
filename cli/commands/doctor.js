import fs from "fs";
import path from "path";
import { resolveProjectRoot } from "./init.js";

const REQUIRED_PATHS = [
    "AGENTS.md",
    ".agents/skills/pipeline-router/SKILL.md",
    ".agents/skills/team-planning/SKILL.md",
    ".agents/skills/execute-task/SKILL.md",
    ".agents/skills/review-delivery/SKILL.md",
    ".agents/skills/resume-session/SKILL.md",
    ".agents/skills/onboard-existing-project/SKILL.md",
    ".agents/skills/structure-project/SKILL.md",
    ".agents/scripts/pipeline.ps1",
    ".agents/scripts/scan_project.ps1",
    ".agents/scripts/plan_team.ps1",
    ".agents/scripts/claim_task.ps1",
    ".agents/scripts/init_project.ps1",
    ".agents/scripts/init_task.ps1",
    ".agents/scripts/validate_pipeline.ps1",
    ".agents/scripts/validate_project.ps1",
    ".agents/scripts/validate_task.ps1",
    ".agents/scripts/status_pipeline.ps1",
    ".agents/templates/architecture.template.md",
    ".agents/references/codex_installation_model.md",
    ".github/pull_request_template.md",
    ".github/workflows/pipeline.yml"
];

const FORBIDDEN_PATHS = [
    ".agents/agents",
    ".agents/core",
    ".agents/registry",
    ".agents/rules",
    ".agents/workflows",
    ".agents/skills/clarify_intent",
    ".agents/skills/design_architecture",
    ".agents/skills/implement_task",
    ".agents/skills/orchestrate_project",
    ".agents/skills/research_existing_project",
    ".agents/skills/validate_delivery"
];

const PROJECT_DOCS = [
    "docs/project/project_status.md",
    "docs/project/backlog.md",
    "docs/project/architecture.md",
    "docs/project/decision_log.md",
    "docs/project/team_plan.md"
];

function exists(root, relativePath) {
    return fs.existsSync(path.join(root, relativePath));
}

function printList(title, items) {
    if (items.length === 0) {
        return;
    }

    console.error(title);
    for (const item of items) {
        console.error(`- ${item}`);
    }
}

export async function doctorCommand() {
    const root = resolveProjectRoot();
    const missing = REQUIRED_PATHS.filter((item) => !exists(root, item));
    const forbidden = FORBIDDEN_PATHS.filter((item) => exists(root, item));
    const missingDocs = PROJECT_DOCS.filter((item) => !exists(root, item));

    printList("Faltando arquivos obrigatorios da pipeline:", missing);
    printList("Estrutura legada encontrada e deve ser removida:", forbidden);

    if (missing.length > 0 || forbidden.length > 0) {
        console.error("Instalacao da pipeline invalida.");
        process.exit(1);
    }

    console.log("Pipeline Codex-native instalada corretamente.");

    if (missingDocs.length > 0) {
        console.log("Docs de projeto ainda nao inicializados.");
        console.log("Use: toug-pipeline init --with-docs");
        console.log("Ou, no Codex, peca: prepare este projeto para a pipeline.");
        return;
    }

    console.log("Docs de projeto encontrados.");
}
