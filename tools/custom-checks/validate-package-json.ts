#!/usr/bin/env node

import path from "path";
import { fileURLToPath } from "url";
import { RuntimeError } from "run-time-error";
import fs from "fs-extra";
import { getAllPkgDirs } from "./get-all-pkg-dirs.js";

export interface IValidatePackageJsonRequest {
  readonly pkgDirsToCheck: Readonly<Array<string>>;
  readonly verbose?: boolean;
  readonly fix?: boolean;
}

export interface IPackageJsonValidationResult {
  readonly packageName: string;
  readonly manifestPath: string;
  readonly errors: string[];
  readonly warnings: string[];
  readonly passed: boolean;
}

export async function validatePackageJson(
  req: IValidatePackageJsonRequest,
): Promise<[boolean, string[]]> {
  const TAG = "[tools/custom-checks/validate-package-json.ts]";
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const SCRIPT_DIR = __dirname;
  const PROJECT_DIR = path.join(SCRIPT_DIR, "../../");

  const errors: string[] = [];
  const warnings: string[] = [];

  if (!req) {
    throw new RuntimeError(`req parameter cannot be falsy.`);
  }
  if (!req.pkgDirsToCheck) {
    throw new RuntimeError(`req.pkgDirsToCheck parameter cannot be falsy.`);
  }

  const verbose = req.verbose === true;
  const autoFix = req.fix === true;

  if (verbose) {
    console.log(`${TAG} SCRIPT_DIR=${SCRIPT_DIR}`);
    console.log(`${TAG} PROJECT_DIR=${PROJECT_DIR}`);
    console.log("%s Package directories to check: %o", TAG, req.pkgDirsToCheck);
    console.log("%s Auto-fix mode: %s", TAG, autoFix);
  }

  const results: IPackageJsonValidationResult[] = [];

  const tasks = req.pkgDirsToCheck.map(async (pkgDir) => {
    const manifestPath = path.join(pkgDir, "package.json");
    const manifestExists = await fs.pathExists(manifestPath);
    
    if (!manifestExists) {
      if (verbose) {
        console.log("%s %s has no package.json. Skipping.", TAG, manifestPath);
      }
      return;
    }

    const result = await validateSinglePackageJson({
      manifestPath,
      pkgDir,
      verbose,
      autoFix,
      TAG,
    });

    results.push(result);
    
    if (result.errors.length > 0) {
      errors.push(...result.errors.map(e => `${result.packageName}: ${e}`));
    }
    if (result.warnings.length > 0) {
      warnings.push(...result.warnings.map(w => `${result.packageName}: ${w}`));
    }
  });

  await Promise.all(tasks);

  // Print summary
  console.log("\n📊 Package.json Validation Summary");
  console.log("=".repeat(50));
  
  const passed = results.filter(r => r.passed);
  const failed = results.filter(r => !r.passed);
  
  results.forEach(result => {
    if (result.errors.length > 0) {
      console.log(`\n❌ ${result.packageName}:`);
      result.errors.forEach(err => console.log(`   - ${err}`));
      if (result.warnings.length > 0) {
        result.warnings.forEach(warn => console.log(`   ⚠️  ${warn}`));
      }
    } else if (result.warnings.length > 0) {
      console.log(`\n⚠️  ${result.packageName}:`);
      result.warnings.forEach(warn => console.log(`   - ${warn}`));
    }
  });
  
  console.log("\n" + "=".repeat(50));
  console.log(`📈 Statistics:`);
  console.log(`   Total packages: ${results.length}`);
  console.log(`   ✅ Passed: ${passed.length}`);
  console.log(`   ❌ Failed: ${failed.length}`);
  console.log(`   ⚠️  Warnings: ${warnings.length}`);
  
  if (failed.length > 0) {
    console.log(`\n💡 Fix the errors above and run again.`);
    if (autoFix) {
      console.log(`   Auto-fix was enabled but couldn't fix all issues.`);
    }
  } else if (warnings.length > 0) {
    console.log(`\n⚠️  All validations passed but warnings exist. Consider fixing them.`);
  } else {
    console.log(`\n✅ All package.json files are valid!`);
  }
  
  return [failed.length === 0, [...errors, ...warnings]];
}

async function validateSinglePackageJson(req: {
  readonly manifestPath: string;
  readonly pkgDir: string;
  readonly verbose: boolean;
  readonly autoFix: boolean;
  readonly TAG: string;
}): Promise<IPackageJsonValidationResult> {
  const { manifestPath, pkgDir, verbose, autoFix, TAG } = req;
  
  const errors: string[] = [];
  const warnings: string[] = [];
  
  try {
    const pkg = await fs.readJson(manifestPath);
    const packageName = pkg.name || path.basename(pkgDir);
    
    // Required fields validation
    const requiredFields = ['main', 'types'];
    for (const field of requiredFields) {
      if (!pkg[field]) {
        errors.push(`Missing required field: "${field}"`);
        continue;
      }
      
      const targetPath = path.join(pkgDir, pkg[field]);
      const targetExists = await fs.pathExists(targetPath);
      
      if (!targetExists) {
        errors.push(`Field "${field}" points to missing file: ${pkg[field]}`);
        if (verbose) {
          console.log("%s Expected file at: %s", TAG, targetPath);
        }
      }
    }
    
    // Module field validation (recommended)
    if (pkg.module) {
      const modulePath = path.join(pkgDir, pkg.module);
      const moduleExists = await fs.pathExists(modulePath);
      if (!moduleExists) {
        warnings.push(`Field "module" points to missing file: ${pkg.module}`);
      }
    } else {
      warnings.push(`Consider adding "module" field for better ES module support`);
    }
    
    // Published package validations
    if (pkg.private !== true) {
      if (!pkg.repository || !pkg.repository.url) {
        warnings.push(`Published package should have "repository.url" field`);
      }
      
      if (!pkg.license) {
        warnings.push(`Published package should have "license" field`);
      }
      
      if (!pkg.description) {
        warnings.push(`Published package should have "description" field`);
      }
    }
    
    // Validate exports field if present (for newer packages)
    if (pkg.exports) {
      await validateExportsField(pkg.exports, pkgDir, warnings, verbose, TAG);
    }
    
    // Auto-fix capabilities (if enabled)
    if (autoFix && errors.length === 0 && warnings.length > 0) {
      // We can implement auto-fix for simple issues
      let modified = false;
      
      if (!pkg.module && pkg.main) {
        // Suggest using same as main for module
        pkg.module = pkg.main;
        warnings.push(`Auto-added "module" field: "${pkg.module}"`);
        modified = true;
      }
      
      if (modified) {
        await fs.writeJson(manifestPath, pkg, { spaces: 2 });
        console.log(`${TAG} Auto-fixed ${manifestPath}`);
      }
    }
    
    return {
      packageName,
      manifestPath,
      errors,
      warnings,
      passed: errors.length === 0,
    };
    
  } catch (error) {
    const errorMsg = error instanceof Error ? error.message : String(error);
    errors.push(`Failed to parse package.json: ${errorMsg}`);
    return {
      packageName: path.basename(pkgDir),
      manifestPath,
      errors,
      warnings,
      passed: false,
    };
  }
}

async function validateExportsField(
  exports: any,
  pkgDir: string,
  warnings: string[],
  verbose: boolean,
  TAG: string,
): Promise<void> {
  const exportsPaths: string[] = [];
  
  if (typeof exports === 'string') {
    exportsPaths.push(exports);
  } else if (typeof exports === 'object') {
    const collectPaths = (obj: any) => {
      for (const key in obj) {
        if (typeof obj[key] === 'string') {
          exportsPaths.push(obj[key]);
        } else if (typeof obj[key] === 'object') {
          collectPaths(obj[key]);
        }
      }
    };
    collectPaths(exports);
  }
  
  for (const exportPath of exportsPaths) {
    const fullPath = path.join(pkgDir, exportPath);
    const exists = await fs.pathExists(fullPath);
    if (!exists) {
      warnings.push(`exports field points to missing file: ${exportPath}`);
      if (verbose) {
        console.log("%s Missing export: %s", TAG, fullPath);
      }
    }
  }
}

// CLI execution
const nodePath = path.resolve(process.argv[1]);
const modulePath = path.resolve(fileURLToPath(import.meta.url));
const isRunningDirectlyViaCLI = nodePath === modulePath;

if (isRunningDirectlyViaCLI) {
  const { absolutePaths: pkgDirsToCheck } = await getAllPkgDirs();
  
  // Parse CLI arguments
  const verbose = process.argv.includes('--verbose') || process.argv.includes('-v');
  const autoFix = process.argv.includes('--fix') || process.argv.includes('-f');
  
  const req: IValidatePackageJsonRequest = {
    verbose,
    fix: autoFix,
    pkgDirsToCheck,
  };
  
  const [success, messages] = await validatePackageJson(req);
  if (!success) {
    messages.forEach((x) => console.error(`\n${x}`));
    process.exit(1);
  }
}