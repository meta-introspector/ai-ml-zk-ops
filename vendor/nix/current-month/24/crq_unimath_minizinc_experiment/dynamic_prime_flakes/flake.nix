{
  description = "A flake that dynamically generates prime number packages, now with emoji encoding.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define a mapping from prime numbers to emojis
        primeToEmojiMap = {
          "2" = "❄️";
          "3" = "➡️";
          "5" = "⬅️";
          "7" = "📦";
          "11" = "⚙️";
          "13" = "💻";
          "17" = "📦❄️";
          "19" = "🛠️❄️";
          # Add more primes and emojis as needed
        };

        primes = [ 2 3 5 7 11 13 17 19 ]; # The first 8 primes

        # Generate packages for each prime, containing its emoji
        emojiPrimePackages = pkgs.lib.genAttrs primes (primeNum:
          let
            primeStr = toString primeNum;
            emoji = primeToEmojiMap.${primeStr} or "❓"; # Use ''?'' for unmapped primes
            packageName = "prime-emoji-${primeStr}";
          in
          pkgs.writeTextFile {
            name = packageName;
            text = emoji;
            destination = "/${packageName}.txt";
          }
        );
      in
      {
        packages = emojiPrimePackages;
      }
    );
}
          "source/automation/generate_oeis_index.sh"
          "source/automation/generate_refactoring_sed_scripts.sh"
          "source/automation/generate_submodule_status.sh"
          "source/automation/generate_unique_github_urls.sh"
          "source/automation/generate_update_lock_command.sh"
          "source/automation/generate-text-to-review.sh"
          "source/automation/gitstatus.sh"
          "source/automation/init_nix_binstore_repo.sh"
          "source/automation/inject_solfunmeme.sh"
          "source/automation/inject_submodule_env.sh"
          "source/automation/inspect_nar_content.sh"
          "source/automation/launch_crq_session.sh"
          "source/automation/move_submodule.sh"
          "source/automation/muses.sh"
          "source/automation/nix_store_size.sh"
          "source/automation/nix_urls.sh"
          "source/automation/nixify_vendor_nix.sh"
          "source/automation/nixify.sh"
          "source/automation/onboard_project.sh"
          "source/automation/parse_nix_flake_errors.sh"
          "source/automation/persona-script.sh"
          "source/automation/process_all_flake_submodules.sh"
          "source/automation/push_main_repo_branch.sh"
          "source/automation/recover.sh"
          "source/automation/restore_deleted_submodule_files.sh"
          "source/automation/restore_nar_and_report.sh"
          "source/automation/review-task.sh"
          "source/automation/run_crq18_forking_script.sh"
          "source/automation/run_gemini.sh"
          "source/automation/run_nixtract_crq_and_log.sh"
          "source/automation/run_submodule_setup.sh"
          "source/automation/run_template_generator.sh"
          "source/automation/run_update_lock_command.sh"
          "source/automation/search_artistic_keywords.sh"
          "source/automation/search_index.sh"
          "source/automation/setup_submodule_for_gemini.sh"
          "source/automation/setup_wikipedia_cache.sh"
          "source/automation/simulate_nix_run.sh"
          "source/automation/spider_wiki_links.sh"
          "source/automation/spidernar.sh"
          "source/automation/stars.sh"
          "source/automation/tag_submodule_with_current_branch.sh"
          "source/automation/test_flake.sh"
          "source/automation/test_generate_llm_context.sh"
          "source/automation/test_nix_environment.sh"
          "source/automation/test_nix_llm_context.sh"
          "source/automation/test_nix_store_restore.sh"
          "source/automation/update_dependencies_one_by_one.sh"
          "source/automation/update_flake_lock.sh"
          "source/automation/update_parent_repos.sh"
          "source/automation/vendorize_all_from_flake_lock.sh"
          "source/automation/vendorize_and_fork_submodule.sh"
          "source/automation/vendorize_flake_lock.sh"
          "source/automation/vendorize_flake_urls.sh"
        ];

        # Function to make a Nix-friendly name from a file path
        toNixName = path:
          let
            # Replace non-alphanumeric characters with hyphens, and remove leading/trailing hyphens
            cleaned = pkgs.lib.replaceStrings [ "/" "." "_" ] [ "-" "-" "-" ] path;
            # Remove duplicate hyphens
            deduplicated = pkgs.lib.replaceStrings [ "--" ] [ "-" ] cleaned;
            # Remove leading/trailing hyphens
            trimmed = pkgs.lib.removePrefix "-" (pkgs.lib.removeSuffix "-" deduplicated);
          in
          trimmed;

        # Path to the 2-gram extraction script
        extract2gramsScript = self + "/extract_2grams.sh";

        # Generate packages for each target file
        generatedPackages = pkgs.lib.genAttrs targetFiles (filePath:
          let
            # Read the content of the file from the ai-ml-zk-ops input
            fileContent = builtins.readFile (ai-ml-zk-ops + "/${filePath}");
            packageName = toNixName filePath;
          in
          pkgs.runCommand "${packageName}-2grams" {
            nativeBuildInputs = [ pkgs.bash ]; # Ensure bash is available
          } ''
            echo "${fileContent}" | ${extract2gramsScript} > $out
          ''
        );
      in
      {
        packages = generatedPackages;
      }
    );
}