{
  description = "A flake to read CRQs and enrich them with emojis using Nix itself.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ai-ml-zk-ops.url = "github:meta-introspector/ai-ml-zk-ops"; # Input for the project repository
  };

  outputs = { self, nixpkgs, flake-utils, ai-ml-zk-ops }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define a simple emoji mapping (this would later come from MiniZinc/RFC)
        emojiMap = {
          "Emoji Nix" = "✨🔢🚀";
          "Nix" = "❄️";
          "Rust" = "🦀";
          "MiniZinc" = "🧩";
          "Lean4" = "✅";
          "Dioxus" = "🖥️";
          "CRQ" = "📜";
          "Plan" = "📝";
          "Goal" = "🎯";
          "Challenge" = "⚠️";
          "Phase 1" = "🏗️";
          "Phase 2" = "🚀";
          "Specification" = "📄";
          "Encoding" = "🔑";
          "Decoding" = "🔓";
          "Integration" = "🔗";
          "Scripting" = "🐚";
          "Optimization" = "📊";
          "Proof" = "🧠";
          "UI" = "🎨";
        };

        # List of CRQ files to process (relative to ai-ml-zk-ops root)
        targetCrqFiles = [
          "docs/crqs/CRQ_037_Emoji_Nix_Implementation_Plan.md"
          "docs/crqs/CRQ_038_Meta_Programming_Emoji_Nix_with_Gemini.md"
          "docs/crqs/CRQ_039_MiniZinc_Optimization_for_Emoji_Nix.md"
        ];

        # Function to apply emoji mapping to text
        applyEmojiMapping = text:
          pkgs.lib.foldlAttrs (acc: key: value:
            builtins.replaceStrings [ key ] [ "${value} ${key}" ] acc
          ) text emojiMap;

        # Generate packages for each CRQ file
        enrichedCrqPackages = pkgs.lib.genAttrs targetCrqFiles (filePath:
          let
            # Read the content of the CRQ file from the ai-ml-zk-ops input
            crqContent = builtins.readFile (ai-ml-zk-ops + "/${filePath}");
            
            # Apply emoji mapping
            enrichedContent = applyEmojiMapping crqContent;

            # Create a Nix-friendly package name
            packageName = pkgs.lib.replaceStrings [ "/" "." "-" ] [ "-" "-" "-" ] (pkgs.lib.removeSuffix ".md" filePath);
          in
          pkgs.writeTextFile {
            name = "emoji-${packageName}";
            text = enrichedContent;
            destination = "/${packageName}.md";
          }
        );
      in
      {
        packages = enrichedCrqPackages;
      }
    );
}