# MTA:SA Roleplay Resources

A comprehensive collection of Multi Theft Auto: San Andreas (MTA:SA) resources powering a roleplay gamemode.

---

## 📋 Overview

This repository contains server and client resources designed for MTA:SA, including character systems, inventory, economy, law enforcement (MDC, radar, roadblocks), dynamic lighting, custom interiors, vehicles, factions, and admin utilities.

### Key Resource Categories

| Category | Resources / Highlights |
| :--- | :--- |
| **Core & Player** | `account`, `saveplayer-system`, `datetime`, `realtime-system`, `global`, `cache` |
| **Economy & Banking** | `bank`, `job-system`, `job-system-trucker`, `payday`, `business-system`, `lottery-system` |
| **Law Enforcement & Emergency** | `mdc`, `camera-system`, `roadblock-system`, `pd-system`, `spike-system`, `es-system`, `LSFD` |
| **Items & Inventory** | `item-system`, `item-world`, `item-texture`, `item-move`, `artifacts` |
| **Vehicles & World** | `[vehicle]`, `[interior]`, `[map]`, `gate-manager`, `elevator-system`, `paynspray-system` |
| **Visuals & Audio** | `dynamic_lighting`, `shader_car_paint`, `shader_radar`, `shader_water`, `fonts` |
| **Administration** | `admin-system`, `anticheat`, `anti-cmdspam`, `report`, `bans`, `serialwhitelist` |

---

## ⚙️ Requirements

- **MTA:SA Server**: Version 1.5.8+ (Windows / Linux)
- **Database**: MySQL 5.7+ or MariaDB 10.4+
- **MTA Modules**: `mta_mysql` module or internal `dbConnect` (MySQL)

---

## 🚀 Setup & Installation

1. **Clone or Copy Resources**:
   Place all resources inside your MTA:SA server directory:
   ```text
   server/mods/deathmatch/resources/
   ```

2. **Database Configuration**:
   Ensure your database connection parameters are configured in your server configuration (`mtaserver.conf`):
   ```xml
   <setting name="*mysql.hostname" value="127.0.0.1" />
   <setting name="*mysql.username" value="mta_user" />
   <setting name="*mysql.password" value="your_password" />
   <setting name="*mysql.database" value="mta" />
   <setting name="*mysql.port" value="3306" />
   ```

3. **Database Migrations & Schemas**:
   - The `mysql` resource includes migration handling (`migrations.lua`).
   - Feature-specific database patches can be found in their respective resource folders (e.g., `mdc/changes.sql`, `factions/db.sql`, `advertisements/advertisements.sql`).

4. **Resource Loading**:
   Add the desired resources to your `mtaserver.conf` startup list or start them through the server console:
   ```text
   start mysql
   start global
   ...
   ```

---

## 📁 Repository Structure Notes

- Bracketed directories like `[map]`, `[interior]`, `[vehicle]`, and `[dev]` are resource group containers recognized by MTA:SA.
- In-game exports and script references should point directly to the resource name without the bracket prefix.

---

## 🔒 Security Best Practices

- **Never commit credentials**: Ensure database passwords, server tokens, and private keys remain in server configuration files outside the repository or in gitignored environment configs.
- **Maintain Binary File Integrity**: Binary files (`.dff`, `.txd`, `.col`, `.png`, `.wav`, etc.) are tracked via `.gitattributes` to prevent CRLF line-ending corruption.

---

## 🤝 Credits & Acknowledgements

This codebase is based on the open-source roleplay gamemode originally developed by the **[OwlGaming Community](https://github.com/OwlGamingCommunity/MTA)**.

Special thanks and credits go to:
- The **OwlGaming MTA Server Development Team** and contributors for the original foundation of these resources.
- The **Multi Theft Auto (MTA:SA)** team for the multiplayer platform and developer APIs.
- Community contributors whose community scripts, maps, shaders, and vehicles are utilized across various resources.

