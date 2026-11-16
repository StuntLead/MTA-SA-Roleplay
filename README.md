# MTA:SA Roleplay Resources

A comprehensive, production-grade Multi Theft Auto: San Andreas (MTA:SA) roleplay gamemode codebase. Built on top of a modular resource architecture and powered by an asynchronous MySQL backend, this package delivers deep simulation mechanics, rich player economies, fine-grained administrative tooling, and immersive world interactions.

---

## 📑 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Comprehensive Feature Catalog](#-comprehensive-feature-catalog)
  - [1. Authentication, Account & Identity](#1-authentication-account--identity)
  - [2. Factions & Organizations](#2-factions--organizations)
  - [3. Economy, Banking & Commerce](#3-economy-banking--commerce)
  - [4. Jobs, Occupations & Logistics](#4-jobs-occupations--logistics)
  - [5. Inventory, Items & World Physics](#5-inventory-items--world-physics)
  - [6. Vehicles, Transport & Dealerships](#6-vehicles-transport--dealerships)
  - [7. Properties, Real Estate & Interiors](#7-properties-real-estate--interiors)
  - [8. Law Enforcement, Emergency & Justice](#8-law-enforcement-emergency--justice)
  - [9. Communication, Phone & Social Systems](#9-communication-phone--social-systems)
  - [10. Environment, Shaders & Visuals](#10-environment-shaders--visuals)
  - [11. Administration, Security & Anticheat](#11-administration-security--anticheat)
  - [12. Developer Tooling & Web Integration](#12-developer-tooling--web-integration)
- [Resource Directory Map](#-resource-directory-map)
- [Requirements](#-requirements)
- [Setup & Installation](#-setup--installation)
- [Configuration Reference](#-configuration-reference)
- [Credits & Acknowledgements](#-credits--acknowledgements)

---

## 🏛️ Architecture Overview

The gamemode utilizes a fully decoupled, event-driven resource topology:
- **Database Engine (`mysql`)**: Managed MySQL/MariaDB pooling with lazy querying, prepared statements, asynchronous polling, and database migrations.
- **Global Pool & Cache (`pool`, `cache`, `global`)**: Low-overhead element indexing across players, vehicles, interiors, and teams with synchronized element data.
- **Protected Network Sync (`anticheat`)**: Element data mutations, state changes, and protected triggers flow through sanitization layers to eliminate memory injection and unauthorized remote execution.
- **Cross-Resource Exports**: Standardized APIs allow plug-and-play extensions without monolithic tight coupling.

---

## 🌟 Comprehensive Feature Catalog

### 1. Authentication, Account & Identity
- **Account Management (`account`)**:
  - Secure registration, login, and salted password hashing.
  - Multi-character selection lobby with live 3D ped preview.
  - Character creator: customizable age, gender, height, weight, ethnicity, origins, starter clothing, and initial funds.
  - In-game account PIN protection for sensitive transactions.
- **State Persistence (`saveplayer-system`)**: Continuous position, health, armor, weapon loadouts, stats, and hunger synchronization to database.
- **Voluntary Character Termination (`selfck-system`)**: In-game workflow for players to voluntarily request permanent character death (CK) with admin logging.
- **Realistic Medical Triage (`death`)**:
  - Incapacitation and bleed-out timers when damage is sustained.
  - Realistic triage states (unconscious, critically wounded, deceased).
  - Medical transport, CPR resuscitation mechanics, and hospital bed recovery spawns.
- **Visual Character Description (`description`)**: 3D spatial floating labels and `/look` interface displaying physical traits, clothing style, accessories, and scars.
- **Dynamic Stamina & Damage Addons (`health-addon`)**: Sprint stamina depletion, limping mechanics on leg trauma, and weapon recoil sway.

---

### 2. Factions & Organizations
- **Comprehensive Faction Engine (`factions`)**:
  - Supports multiple distinct faction classifications:
    - `0: Gang`
    - `1: Mafia`
    - `2: Law Enforcement (LSPD / SASD)`
    - `3: Government (Executive / Judiciary / Mayoralty)`
    - `4: Medical & Emergency (LSFD / EMS)`
    - `5: Other / Private Groups`
    - `6: News & Media (SAN)`
    - `7: Commercial Dealership`
  - **Dynamic Rank Hierarchies**: Fully customizable rank orders, custom permissions per rank (duty access, vehicle spawn, finances, member promotion/demotion), and custom wages.
  - **Self-Healing Fallbacks**: Automatic recovery routines that detect and regenerate missing or corrupted ranks without menu crashes.
  - **Gap-Filling ID Allocation**: Automatically locates and reclaims the lowest missing numeric ID when creating factions, preventing gaps and database counter drift.
  - **In-Game Faction Panel (F3 / `/faction`)**: Manage rosters, online states, leader assignments, MOTD, faction notes, wages, duty rosters, and towed vehicle statistics.
- **Custom Duty Engine (`duty`)**: Custom duty outfits, loadouts, locations (fixed interior/exterior points and duty vehicles), weapon issues, and kevlar armor sets.
- **Democratic Elections (`elections`)**: In-game ballot boxes, candidate campaigning, voter registration, and automated tallying for mayoral and representative seats.

---

### 3. Economy, Banking & Commerce
- **Central Banking System (`bank`)**:
  - Personal checking accounts, business accounts, and faction treasuries.
  - Interactive ATMs distributed across San Andreas with animated UI.
  - Direct wire transfers with real-time debiting, transaction notes, and audit logs.
  - Physical debit/credit cards tied to accounts with PIN verification (`cards`).
- **Commercial Enterprises (`business-system`)**:
  - Player-owned commercial storefronts with custom profit margins and stock replenishments.
  - Custom cash register transactions, sales tax calculation, and employee wage disbursement.
- **Automated Hourly Payday (`payday`)**:
  - Scheduled hourly calculation of employment wages, faction salaries, and welfare assistance.
  - Progressive income tax deductions and municipal asset taxes (property and vehicle taxation).
  - Accrued bank account interest calculation and detailed breakdown receipts.
- **State Lottery System (`lottery-system`)**: Automated lottery draws, ticket vendor purchasing, progressive jackpot accumulation, and server-wide winner announcements.
- **Asset Insurance (`insurance`)**: Policy coverage management for vehicles and properties against accidental destruction and structural damage.

---

### 4. Jobs, Occupations & Logistics
- **Civilian Occupations (`job-system`)**:
  - **Taxi / Cab Operator**: Interactive fare meters, passenger billing, and route pickups.
  - **Public Bus Driver**: Timed metropolitan and rural passenger routes with automated bus stop rewards.
  - **Delivery Driver**: Warehouse depot pick-up and urban package drop-offs.
  - **City Maintenance & Sweeper**: Street cleaning routes and municipal sanitation upkeep.
  - **Mechanic**: Mobile towing, vehicle repairs, body panel adjustments, and engine tune-ups.
- **Long-Haul Freight Logistics (`job-system-trucker`)**:
  - Heavy semi-truck delivery contracts with detachable freight trailers.
  - Supply deliveries connecting seaports, industrial factories, and retail stores.
  - Fragile and hazardous cargo penalties with dynamic payment based on delivery distance.

---

### 5. Inventory, Items & World Physics
- **Grid Inventory System (`item-system`)**:
  - Graphical grid-based inventory with item weight limits, drag-and-drop movement, and hotbar slots.
  - Extensive item catalog: food, beverages, keys, smartphones, identification cards, weapons, ammunition magazines, first aid kits, repair tools, vehicle components, narcotics, and clothing items.
- **World Space Pickups (`item-world`)**:
  - Drop any physical item into 3D world space with accurate visual models and collision physics.
  - Persistent world item states stored in MySQL across server reboots.
- **3D Interior Gizmo (`item-move`)**: Precision in-game 3D translation and rotation handles to place decorative items, furniture, and inventory props in properties.
- **Custom Material Texturing (`item-texture`, `texture-system`)**: In-game shader mapping allowing players to apply custom image textures to clothing, vehicles, and world objects.
- **Street Graffiti & Tags (`tag-system`)**: In-game spray cans that draw persistent graffiti artwork onto world walls, cleanable by street sweepers and law enforcement with sponges.

---

### 6. Vehicles, Transport & Dealerships
- **Vehicle Simulation (`[vehicle]/vehicle`)**:
  - Realistic engine ignition, stall mechanics, battery drain, and starter health.
  - Accurate damage synchronization: headlights, windows, doors, tires, and bumper panels.
  - Trunk and glovebox storage with secure physical key/lock authorization.
  - Handbrake, cruise control, tinted windows (`tintedwindows`), and functional sirens.
  - First-person cockpit perspective camera (`cockpit`).
- **Interactive Fuel System (`[vehicle]/vehicle_fuel`)**:
  - Dynamic fuel consumption based on vehicle model, engine displacement, and velocity.
  - Interactive fuel pumps across all gas stations with multiple fuel grades and portable jerrycans.
- **Fleet Management & Admin Suite (`[vehicle]/vehicle_manager`)**:
  - Administrative GUI for vehicle spawning, color adjustment, upgrades, coordinate tracking, and owner transfers.
  - Comprehensive database query logs tracing every vehicle sale, deletion, and movement.
- **Mobile Vehicle Interiors (`[vehicle]/vehicle-interiors`)**: Walkable physical interior spaces inside large vehicle classes (RVs, luxury motor coaches, ambulances, yachts).
- **Dealership Showrooms (`[vehicle]/carshop-system`)**: Interactive car dealerships with vehicle inspection, color selection, test drives, down payments, and inventory stock.
- **Vehicle Audio (`[vehicle]/carradio`)**: Custom streaming internet radios with in-dash station tuning, presets, and 3D spatial audio heard by nearby bystanders.
- **Department of Motor Vehicles (`[vehicle]/vehicleplate`)**: Custom license plate registrations, vehicle registration documents, and ownership titles.
- **Tow & Impound Operations (`tow-system`)**:
  - Realistic winch and flatbed towing physics.
  - Municipal impound lots, impound logging, violation fines, and release workflows.
- **Service Garages (`paynspray-system`)**: Pay 'N' Spray garages featuring animated roll-up shutter doors and automated vehicle restoration.

---

### 7. Properties, Real Estate & Interiors
- **Dynamic Property Framework (`[interior]/interior_system`)**:
  - Houses, high-rise apartments, retail businesses, commercial warehouses, and civic buildings.
  - Real estate market: purchasing, leasing, property tax assessments, and foreclosure repossessions.
  - Physical locks, duplicate key cutting, knock-on-door audio, and interior door bell chimes.
- **Property Administration (`[interior]/interior-manager`)**: Visual administration tools for creating interior entrances, editing coordinate markers, adjusting dimension IDs, and configuring sale values.
- **Electronic Security Keypads (`[interior]/interior_keypad`)**: Numerical door security keypads featuring PIN access codes, tamper alarms, and lockouts.
- **Multi-Level Elevators (`elevator-system`)**: Seamless multi-floor vertical elevator lifts connecting basements, main lobbies, and rooftop helipads.
- **Automated Gates & Security Barriers (`gate-manager`)**: Motorized gates, road barriers, and security bollards controllable via remote keys, access codes, or authorized faction duty.

---

### 8. Law Enforcement, Emergency & Justice
- **Mobile Data Computer (`mdc`)**:
  - Integrated terminal for Law Enforcement, Fire/EMS, and Government officials.
  - Real-time criminal warrant queries, APB (All-Points Bulletins), and BOLO alerts.
  - Citizen criminal histories, active traffic infractions, license validity checks, and registered firearm tracking.
  - Department of Motor Vehicles registration lookups and emergency 911 dispatch calls.
- **Tactical Law Enforcement Mechanics (`pd-system`)**:
  - Suspect restraint (handcuffs, zip-ties) and escorting.
  - Non-lethal taser weapon mechanics with realistic stun convulsions.
  - In-field pat-down frisking, vehicle searches, blood-alcohol breathalyzers, and contraband seizure.
- **Tactical Enforcements (`roadblock-system`, `spike-system`)**:
  - Deployable traffic control assets (traffic cones, reflective barricades, wooden barriers, crime scene tape).
  - Deployable stinger spike strips that pop and destroy tires of pursuing vehicles.
- **Video Surveillance (`camera-system`)**: City-wide network of live CCTV surveillance cameras with remote pan, tilt, zoom, and night-vision monitoring stations.
- **Correctional Justice (`prison-system`)**:
  - San Andreas Correctional Facility (SACF) and precinct holding cells.
  - Automated sentence countdown timers, bail payment processing, and prison inmate jumpsuits.
- **Fire & Rescue Services (`LSFD`, `es-system`)**:
  - Emergency station dispatch alarms, bells, and handheld pagers.
  - Realistic structural fire propagation, water cannon extinguishing, and hose connections.
  - Paramedic stretchers, defibrillator shock mechanics, and burn injury treatment.
- **Ballistics & Weaponry (`weapon`, `weaponcap`)**:
  - Visible weapon holster and sling attachments on character bodies (`weapon/attach`).
  - Realistic reload mechanics, custom sound packs, recoil management, and ammunition limits.
  - Ballistic shell casing drops tied to firearm serial numbers for forensic analysis.

---

### 9. Communication, Phone & Social Systems
- **Realistic Proximity Chat (`chat-system`)**:
  - Distance-attenuated in-character speech: `/say`, `/whisper`, `/low`, `/shout`, and `/megaphon`.
  - Emote expression syntax: `/me`, `/do`, and ambient roleplay commands.
  - Out-of-character communication channels: `/b` local OOC, private messaging (`/pm`), and admin broadcasts.
  - Two-way radio communication with tuneable radio frequencies, faction dispatch channels, and encryption channels.
- **Smart Mobile Devices (`phone`)**:
  - Interactive graphical smartphone user interface.
  - Outgoing voice calls, contact address books, and SMS text message threads with timestamps.
  - 911 emergency services dispatch routing with automatic GPS caller tracking.
  - Ringtone audio selection and silent modes.
- **Multi-Lingual Dialogue (`language-system`)**:
  - Spoken in-character languages (English, Spanish, Russian, Italian, Japanese, French, German, Arabic, etc.).
  - Realistic scrambled text for listeners who are not fluent in the spoken language.
  - Language proficiency improvement through practice and in-game learning.
- **Public Advertisements (`advertisements`)**: Commercial broadcast ads routed through the news network, charging per-character fees and linking caller contact numbers.
- **Chance & Tabletop Roleplay (`chance-system`)**: Roll mechanics for table roleplay resolution: `/coin`, `/dice`, and probabilistic percentage rolls.
- **Animation Suite (`animation-system`)**: Library of hundreds of roleplay character animations (smoking, sitting, leaning, athletic stances, emotional reactions, dances).
- **Physical Furniture Sitting (`sittablechairs`)**: Interactive world benches, armchairs, and dining seats allowing players to naturally sit down.

---

### 10. Environment, Shaders & Visuals
- **Dynamic Climate & Seasons (`weather`, `weather-system`)**:
  - Dynamic weather cycles (Clear, Overcast, Foggy, Rainy, Thunderstorm) synchronized with ambient temperatures.
  - Winter weather support with physical falling snowflakes (`snow`) and ground snow shaders (`shader_snow_ground`).
- **Real-Time Clocks (`datetime`, `realtime-system`)**: Clock synchronization supporting accelerated game cycles or 1:1 real-world clock time matching.
- **Advanced Dynamic Lighting Engine (`dynamic_lighting`)**:
  - Deferred point-lighting shaders illuminating street poles, interior lamps, and character flashlights.
  - Dynamic vehicle lighting: high-beams, tail lights, and directional multi-pattern emergency strobe lightbars (`dynamic_lighting_vehicles`).
- **Post-Processing Shaders**:
  - **Vehicle Paint Reflections (`shader_car_paint`)**: Enhanced specular environment reflections on vehicle bodywork.
  - **Water Surface (`shader_water`)**: High-fidelity normal-mapped water rendering with wave foam.
  - **Minimap Radar (`shader_radar`)**: Stylized custom radar HUD rendering.

---

### 11. Administration, Security & Anticheat
- **Tiered Administrative Hierarchy (`admin-system`, `integration`)**:
  - Structured staff permissions: Trial Admin, Admin, Senior Admin, Lead Admin, Head Admin, and Executive.
  - Administrative tools: `/goto`, `/gethere`, `/freeze`, `/sethp`, `/giveitem`, `/setfaction`, `/recon`, `/disguise`, and offline player lookups.
- **Active Anticheat Defenses (`anticheat`, `anti-cmdspam`)**:
  - Real-time client heuristic checks detecting speed manipulation, air-break, godmode, weapon injection, and health hacking.
  - Rate-limiting protection preventing command spam and denial-of-service event floods.
- **Ticketing & Support (`report`)**:
  - In-game player helpdesk and report management system.
  - Admin claim assignments, player teleports, live ticket chat, and resolution tracking.
- **Enforcement & Access Control (`bans`, `serialwhitelist`)**:
  - Hardware Serial (MTA serial) and IP address banning with ban appeal timestamps.
  - Optional hardware serial whitelist gate for private or closed-testing environments.
- **Comprehensive Audit Trail (`logs`, `OwlGamingLogs`)**: Structured relational database logs capturing chat lines, item transfers, bank wire movements, vehicle transactions, and admin commands.

---

### 12. Developer Tooling & Web Integration
- **In-Game Development Tools (`[dev]`)**:
  - **`runcode`**: In-game real-time Lua execution environment for testing server and client code snippets.
  - **`sfxbrowser`**: Audio browser for testing and previewing GTA audio banks and sound effects.
  - **`ipb`**: Forum account synchronization module for IPB/Invision Community platforms.
- **RESTful Administration API (`admin-api`, `admin-panel`)**: Lightweight HTTP API bridge enabling external web panels, Discord bots, and UCP services to monitor server status, manage players, and query faction data.

---

## 🗂️ Resource Directory Map

```text
resources/
├── account/                    # Authentication, login lobby, and character creation
├── admin-api/                  # REST API server for external web panels and tools
├── admin-panel/                # Web control panel sub-project
├── admin-system/               # Administration commands and staff management
├── advertisements/             # Classified ads and San Andreas News announcements
├── animation-system/           # Extensive roleplay character animation library
├── anticheat/                  # Client verification, cheat detection, and event sanitization
├── anti-cmdspam/               # Command rate-limiting and flood defense
├── apps/                       # In-game application forms and certification tests
├── artifacts/                  # Special inventory collectibles and unique items
├── bank/                       # Personal/business bank accounts, ATMs, and wire transfers
├── bans/                       # Hardware serial and IP ban management
├── bone_attach/                # Library for attaching 3D objects to player skeletal bones
├── business-system/            # Player-owned businesses, commercial registers, and profit margins
├── cache/                      # Server-side cache for account, character, and faction queries
├── camera-system/              # City-wide CCTV surveillance cameras and control panels
├── cards/                      # Credit/debit cards, identification badges, and licenses
├── cargo/                      # Freight shipping crates and logistics inventory
├── chance-system/              # Tabletop dice and probability roll commands
├── chat-system/                # Local IC proximity chat, whispers, shouts, and OOC channels
├── clothes/                    # Custom clothing items and wardrobe outfit customization
├── clubtec/                    # Nightclub visual DJ lighting and stage smoke equipment
├── cockpit/                    # First-person in-cabin vehicle driving camera
├── colorblender/               # Dynamic RGB color mixing utilities
├── computers-system/           # Interactive in-game desktop PC and laptop terminals
├── customblips/                # Custom high-definition minimap icons and map blips
├── dancer-system/              # Automated dancing NPC animations for clubs and venues
├── datetime/                   # Synchronized server date, month, and year calendar
├── death/                      # Realistic bleeding, injury triage, revive timers, and hospitals
├── description/                # 3D spatial floating character descriptions (/look)
├── donators/                   # Premium donor perks, custom titles, and vehicle features
├── driveby/                    # Passenger and driver firearm drive-by shooting mechanics
├── duty/                       # Faction duty loadouts, duty skins, and weapon lockers
├── dynamic_lighting/           # Deferred lighting shader engine for lamps, flashlights, and lights
├── dynamic_lighting_flash/     # Flashlight cone shader integration
├── dynamic_lighting_vehicles/  # Dynamic vehicle headlights, brake lights, and emergency strobes
├── elections/                  # In-game ballot voting and municipal mayoral elections
├── elevator-system/            # Multi-floor building elevators and roof teleporters
├── es-system/                  # Emergency medical services triage and ambulance equipment
├── event-system/               # In-game community event coordination and prize distribution
├── factions/                   # Multi-faction management, ranks, wages, F3 GUI, and lowest-ID logic
├── fakevideo/                  # Simulated video playback effects on in-game screens
├── fonts/                      # Custom TrueType font packages for user interfaces
├── forums/                     # Web forum link utilities and notification integration
├── freecam/                    # Free-roaming spectator camera for staff and cinematic recording
├── freecam-tv/                 # Television broadcast feed perspective camera
├── gate-manager/               # Automatic and keycard-controlled security gates and barriers
├── gatekeepers-system/         # NPC security guards and gate receptionists
├── global/                     # Shared global utility library, money math, and name lookups
├── glue-system/                # Player attachment mechanics for vehicle flatbeds and aircraft
├── gps/                        # In-car GPS turn-by-turn waypoint navigation
├── grid/                       # Grid calculation utilities for inventory positioning
├── guied/                      # Visual graphical interface design and layout editor
├── hardwaresurvey/             # Anonymous client hardware diagnostics and resolution collection
├── health-addon/               # Dynamic physical stamina, sprint exhaustion, and limb injuries
├── heligrab/                   # Helicopter skid hanging and aerial extraction mechanics
├── help/                       # Beginner tutorial guides, command references, and FAQs
├── hud/                        # Heads-up display: health, armor, money, speedometer, and radar
├── id-system/                  # Temporary session player ID assignment and lookups
├── insurance/                  # Vehicle and property damage insurance policy management
├── integration/                # Staff rank permission verification and administrative hierarchies
├── item-move/                  # 3D translation/rotation gizmo for furnishing interiors
├── item-system/                # Graphical grid inventory, item weights, and hotbar slots
├── item-texture/               # Custom material shaders applied to clothing and vehicle models
├── item-world/                 # Physical 3D item pickups dropped in the game world
├── job-system/                 # Civilian professions: taxi, bus, delivery, mechanic, sweeper
├── job-system-trucker/         # Long-haul logistics contracts and semi-trailer deliveries
├── language-system/            # Spoken in-character languages with realistic scrambled dialogue
├── license-system/             # DMV driving tests, pilot certificates, and weapon licenses
├── logs/                       # Comprehensive database transaction and action auditing
├── lottery-system/             # Server-wide lottery drawings and cumulative jackpots
├── LSFD/                       # Los Santos Fire Department bells, pagers, hoses, and fire alarms
├── mdc/                        # Mobile Data Computer: warrants, APBs, records, and dispatch calls
├── model-system/               # Custom DFF/TXD model loading and replacement engine
├── modloader/                  # Dynamic vehicle and skin mod allocation
├── mods/                       # Custom mod files and resources
├── mysql/                      # MySQL database connector, query pooling, and migrations
├── npc/                        # Interactive non-player characters with dialog prompts
├── object-browser/             # In-game GTA object search and preview catalog
├── object-interaction/         # Context menu right-click interactions with world objects
├── object-system/              # Persistent custom object placement and interior furnishing
├── OwlGamingLogs/              # High-throughput logging bridge
├── parachute/                  # Parachute mechanics and skydiving equipment
├── payday/                     # Hourly wage disbursement, progressive taxation, and bank interest
├── paynspray-system/           # Pay 'N' Spray auto repair garages with automated shutter doors
├── pd-system/                  # Law enforcement handcuffs, tasers, breathalyzers, and suspect searches
├── ped-system/                 # Static ped actors, shop clerks, and atmospheric civilians
├── phone/                      # Interactive smartphone GUI: voice calls, SMS, contacts, and 911
├── pool/                       # Fast element allocation and lookup tables by database ID
├── prison-system/              # Correctional facility detention, bail processing, and inmate uniforms
├── ramp-system/                # Deployable stunt and vehicle loading ramps
├── realism/                    # Realistic vehicle roll-over physics and engine stalls
├── realtime-system/            # Synchronized real-world clock time
├── release-notes/              # In-game patch notes and update announcement dialog
├── report/                     # Player support ticketing system with admin claim workflows
├── resources/                  # Resource state supervisor and restart utilities
├── rightclick/                 # 3D world contextual right-click interaction menu
├── roadblock-system/           # Deployable traffic cones, barricades, and crime scene tape
├── san/                        # San Andreas News broadcast and press van transmission systems
├── sapt-system/                # Public transit scheduling and route tracking
├── saveplayer-system/          # Persistent character coordinates, health, and armor database saving
├── scoreboard/                 # Graphical player list (TAB) with ping, ID, and staff indicators
├── selfck-system/              # Player-initiated character death confirmation workflows
├── serialwhitelist/           # Hardware serial whitelist access control gate
├── sfia/                       # San Fierro International Airport gate and terminal logic
├── shader_car_paint/           # High-definition vehicle specular reflection shader
├── shader_radar/               # Custom radar map texture shader
├── shader_snow_ground/         # Winter terrain ground snow coverage shader
├── shader_water/               # Realistic water surface shader with normal mapping
├── sittablechairs/             # Sit interactively on world chairs, couches, and park benches
├── snow/                       # Falling winter snowflake particle effects
├── social/                     # Player contact lists and social networking features
├── spike-system/               # Deployable vehicle spike strips for police pursuits
├── superman/                   # Administrative free-flight utility
├── tag-system/                 # Spray can wall graffiti with persistent tag graphics
├── texture-system/             # Dynamic texture replacement framework
├── tintedwindows/              # Vehicle window tinting levels affecting visibility
├── toll/                       # Highway toll booths with automated barrier gates
├── tow-system/                 # Tow truck crane physics, impound lots, and release fines
├── usercontrolpanel/           # In-game user account management panel
├── weapon/                     # Realistic weapon handling, reload animations, and holster attachments
├── weaponcap/                  # Maximum weapon carrying capacity enforcement
├── weather/                    # Ambient temperature calculations and regional weather
├── weather-system/             # Dynamic weather forecast cycles
├── xmas/                       # Holiday Christmas trees, festive decorations, and music
├── [dev]/                      # Developer utilities: runcode, sfxbrowser, ipb forum sync
├── [interior]/                 # Properties: interior_system, interior-manager, keypads, teleporters
├── [map]/                      # Custom GTA map loaders and map management tools
└── [vehicle]/                  # Vehicles: fuel, vehicle_manager, dealerships, mobile interiors, radios
```

---

## ⚙️ Requirements

- **Server Platform**: Multi Theft Auto: San Andreas (MTA:SA) Server **v1.5.8** or newer (Windows / Linux)
- **Database Engine**: MySQL **5.7+** or MariaDB **10.4+**
- **Character Encoding**: `utf8mb4` recommended for comprehensive multilingual and emoji support
- **MTA Modules**: Internal `dbConnect` (standard) or `mta_mysql` module

---

## 🚀 Setup & Installation

### 1. Placement
Place the contents of this repository into your MTA:SA server's resources directory:
```text
server/mods/deathmatch/resources/
```

> [!NOTE]
> Directories wrapped in brackets (e.g., `[vehicle]`, `[interior]`, `[map]`, `[dev]`) are resource group containers. MTA:SA loads the resources nested inside them as standard individual resources. In scripts and export calls, reference the resource directly by name without the brackets (e.g., `exports.vehicle_manager`, not `exports["[vehicle]/vehicle_manager"]`).

### 2. Database Setup
Create a new database in MySQL/MariaDB:
```sql
CREATE DATABASE `mta` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Configure your database connection parameters in your server configuration file (`mtaserver.conf`):
```xml
<setting name="*mysql.hostname" value="127.0.0.1" />
<setting name="*mysql.username" value="mta_user" />
<setting name="*mysql.password" value="your_password" />
<setting name="*mysql.database" value="mta" />
<setting name="*mysql.port" value="3306" />
```

### 3. Startup Order
To ensure proper dependency resolution, initialize core libraries and the database connector prior to gameplay systems:
```text
start mysql
start pool
start cache
start global
start anticheat
start account
start saveplayer-system
start factions
start item-system
start [interior]
start [vehicle]
```

---

## 🔒 Security Best Practices

- **Never Commit Production Passwords**: Keep production database credentials and API secrets in `mtaserver.conf` or gitignored environment configurations.
- **Binary File Integrity**: Binary assets (`.dff`, `.txd`, `.col`, `.png`, `.wav`, `.mp3`) are tracked via `.gitattributes` to prevent CRLF line-ending corruption during Git checkouts.
- **Protected Element Data**: Sensitive element data is marked as protected and synced exclusively through `exports.anticheat:changeProtectedElementDataEx` to prevent client-side injection.

---

## 🤝 Credits & Acknowledgements

This codebase is based on the open-source roleplay gamemode originally created and maintained by the **[OwlGaming Community](https://github.com/OwlGamingCommunity/MTA)**.

Special thanks to:
- The **OwlGaming MTA Server Development Team** for the foundational framework.
- The **Multi Theft Auto Team** for their multiplayer platform, Lua engine, and developer tooling.
- The MTA open-source community for shared shaders, maps, models, and community contributions.
