
# [QB] Police Badge

A QB-Core Police Badge Script!
Displays Callsign, Rank & Name Of The Officer!

## Screenshot
![My Remote Image](https://cdn.discordapp.com/attachments/992322942933418024/1074427349610811392/image.png)
## How To Install

- Add This To Your QB Core > Shared > Items.lua	
`["specialbadge"]                 = {["name"] = "specialbadge",                  ["label"] = "Police Badge",             ["weight"] = 1000,      ["type"] = "item",      ["image"] = "specialbadge.png",         ["unique"] = false,     ["useable"] = true,     ["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Special Badge of Law Enforcements"},`
- Drag & Drop the resource folder to your `resources` directory.
- Make sure the folder is named **`chilllixhub-policebadge`** (matching the `fxmanifest.lua`).
- Add `ensure chilllixhub-policebadge` to your `server.cfg`.
- Add the badge image to `qb-inventory > html > images` (rename it to `specialbadge.png`).

![specialbadge](https://user-images.githubusercontent.com/73050572/218711638-f56a8876-3773-495c-9b6a-612d7d736f77.png)

## Configuration

The badge headshot overlay position is determined automatically based on the viewer's screen resolution.
A default fallback position (1920×1080 values) is used for any resolution not explicitly listed in `cl_badge.lua`.
You can adjust the defaults or add new entries in the `resolutionBadgePos` table near the bottom of `cl_badge.lua`.

## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://linktr.ee/roski123)
[![linkedin](https://img.shields.io/badge/instagram-0A66C2?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/parikshitgg/)



## 🛠 Skills
Javascript, HTML, CSS, LUA


## Licenses

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)

