#!/usr/bin/env node

import path from "path";
import { getPackageRoot, installPipeline } from "./commands/init.js";

function isTruthy(value) {
    return ["1", "true", "yes"].includes(String(value ?? "").toLowerCase());
}

function shouldSkip(targetRoot, packageRoot) {
    if (isTruthy(process.env.TOUG_PIPELINE_SKIP_AUTO_INSTALL)) {
        return "TOUG_PIPELINE_SKIP_AUTO_INSTALL is set.";
    }

    if (process.env.npm_config_global === "true") {
        return "global install detected.";
    }

    if (path.resolve(targetRoot) === path.resolve(packageRoot)) {
        return "package repository install detected.";
    }

    if (targetRoot.includes(`${path.sep}node_modules${path.sep}`)) {
        return "node_modules target detected.";
    }

    return null;
}

const packageRoot = getPackageRoot();
const targetRoot = process.env.INIT_CWD || process.cwd();
const skipReason = shouldSkip(targetRoot, packageRoot);

if (skipReason) {
    console.log(`[toug-pipeline] Auto-install skipped: ${skipReason}`);
    process.exit(0);
}

try {
    installPipeline({
        targetRoot,
        withDocs: false,
        force: false,
        quiet: true
    });

    console.log("[toug-pipeline] Installed AGENTS.md, .agents/ and .github/ in this project.");
    console.log("[toug-pipeline] Open Codex and ask: qual o estado atual da pipeline?");
} catch (error) {
    console.log(`[toug-pipeline] Auto-install skipped: ${error.message}`);
    console.log("[toug-pipeline] To install or update manually, run: npx toug-i.a-pipeline-team init --force");
}
