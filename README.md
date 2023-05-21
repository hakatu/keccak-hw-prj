# Keccak Hardware Project: SHAKE and SHA-3 Accelerator on FPGA

This project provides an FPGA-based accelerator for the SHAKE and SHA-3 cryptographic hashing functions, specifically SHAKE-128, SHAKE-256, SHA3-256, and SHA3-512. The project has been tested using Python libraries.

## Structure of the Repository

This repository is organized into the following directories:

### `AllworldSHA`

This directory contains SystemVerilog (.sv) files for various components of the Keccak hashing function, such as `chi.sv`, `iota.sv`, `keccak_f_1600.sv`, `keccak_globals.vhd`, `keccak_round.sv`, `keccak_round.vhd`, `keccak_round_constants_gen.sv`, `pi.sv`, `rho.sv`, `tb_iota.sv`, `tb_keccak_f_1600.sv`, `tb_keccak_round.sv`, and `theta.sv`&#8203;`oaicite:{"index":0,"metadata":{"title":"github.com","url":"https://github.com/hakatu/keccak-hw-prj/tree/main/Keccak/AllworldSHA","text":"AllworldSHA\n\nchi.sv\n\niota.sv\n\nkeccak_f_1600.sv\n\nkeccak_globals.vhd\n\nkeccak_round.sv\n\nkeccak_round.vhd\n\nkeccak_round_constants_gen.sv\n\nkeccak_round_constants_gen.sv.bak\n\npi.sv\n\nrho.sv\n\ntb_iota.sv\n\ntb_keccak_f_1600.sv\n\ntb_keccak_round.sv\n\ntheta.sv","pub_date":null}}`&#8203;.

### `Keccak`

This directory contains VHDL files necessary for the Keccak implementation, which are `keccak.vhd`, `keccak_buffer.vhd`, `keccak_globals.vhd`, `keccak_round.vhd`, and `keccak_round_constants_gen.vhd`&#8203;`oaicite:{"index":1,"metadata":{"title":"github.com","url":"https://github.com/hakatu/keccak-hw-prj/tree/main/Keccak/Keccak-256","text":"Following Keccak VHDL coeds from \"High-speed core design\" in the Website \"The Keccak sponge function family (http://keccak.noekeon.org/KeccakVHDL-2.0.zip)\" are required for this implementation.\n\n    keccak.vhd\n    keccak_buffer.vhd\n    keccak_globals.vhd\n    keccak_round.vhd\n    keccak_round_constants_gen.vhd","pub_date":null}}`&#8203;.

### `mdsimkeccak`

This directory contains simulation files such as `keccak.cr.mti`, `keccak.mpf`, `vsim.wlf`, and `wlftaw65mt`&#8203;`oaicite:{"index":2,"metadata":{"title":"github.com","url":"https://github.com/hakatu/keccak-hw-prj/tree/main/Keccak/mdsimkeccak","text":"workflow \n    *  Packages Host and manage packages \n    *  Security Find and fix vulnerabilities \n    *  Codespaces Instant dev environments \n    *  Copilot Write better code with AI \n    *  Code review Manage code changes \n    *  Issues Plan and track work \n    *  Discussions Collaborate outside of code \n\nExplore\n    *  All features \n    *  Documentation \n    *  GitHub Skills \n    *  Blog \n\n  * Solutions \n\nFor\n    *  Enterprise \n    *  Teams \n    *  Startups \n    *  Education \n\nBy Solution\n    *  CI/CD & Automation \n    *  DevOps \n    *  DevSecOps \n\nCase Studies\n    *  Customer Stories \n    *  Resources \n\n  * Open Source \n\n    *  GitHub Sponsors Fund open source developers \n\n    *  The ReadME Project GitHub community articles \n\nRepositories\n    *  Topics \n    *  Trending \n    *  Collections \n\n  * Pricing \n\n  *  In this repository All GitHub ↵ Jump to ↵  \n\n  * No suggested jump to results\n\n  *  In this repository All GitHub ↵ Jump to ↵  \n  *  In this user All GitHub ↵ Jump to ↵  \n  *  In this repository All GitHub ↵ Jump to ↵  \n\n Sign in  \n\n Sign up  \n\n{{ message }}\n\n hakatu   / keccak-hw-prj  Public\n\n  *  Notifications  \n  *  Fork 0  \n  *  Star 0  \n\n  *  Code  \n  *  Issues 0 \n  *  Pull requests 1 \n  *  Actions  \n  *  Projects 0 \n  *  Security \n  *  Insights  \n\nMore\n\n  *  Code  \n  *  Issues  \n  *  Pull requests  \n  *  Actions  \n  *  Projects  \n  *  Security  \n  *  Insights  \n\n  main\n\nSwitch branches/tags\n\nBranches Tags\n\nCould not load branches\n\nNothing to show\n\n {{ refName }} default   View all branches\n\nCould not load tags\n\nNothing to show\n\n {{ refName }} default  \n\nView all tags\n\n# Name already in use\n\nA tag already exists with the provided branch name. Many Git commands accept both tag and branch names, so creating this branch may cause unexpected behavior. Are you sure you want to create this branch? \n\nCancel  Create \n\nkeccak-hw-prj/Keccak/mdsimkeccak/\n\n Go to file  \n\nkeccak-hw-prj/Keccak/mdsimkeccak/\n\n## Latest commit\n\n## Git stats\n\n  *  History  \n\n## Files\n\nPermalink \n\nFailed to load latest commit information. \n\nType\n\nName\n\nLatest commit message\n\nCommit time\n\n . .  \n\nwork\n\nkeccak.cr.mti\n\nkeccak.mpf\n\nvsim.wlf\n\nwlftaw65mt","pub_date":null}}`&#8203;.

### `qsimkeccakroundmixvvhd`

This directory contains simulation files such as `keccak_round.cr.mti`, `keccak_round.mpf`, `transcript`, and `vsim.wlf`&#8203;`oaicite:{"index":3,"metadata":{"title":"github.com","url":"https://github.com/hakatu/keccak-hw-prj/tree/main/Keccak/qsimkeccakroundmixvvhd","text":"work\n\nkeccak_round.cr.mti\n\nkeccak_round.mpf\n\ntranscript\n\nvsim.wlf","pub_date":null}}`&#8203;.

## How to Use

The `top_module.sv` file serves as the top-level file for this project. As this is a hardware project, usage will depend on the specific hardware and VHDL environment being used. In general, however, you should be able to clone the repository and include the necessary files in your VHDL project.

## Running Tests

Tests can be run using the `vector_testbench.sv` file.

## Contributing

No contributions are currently being accepted for this project.

## License

This project is licensed under the terms of the MIT license.
