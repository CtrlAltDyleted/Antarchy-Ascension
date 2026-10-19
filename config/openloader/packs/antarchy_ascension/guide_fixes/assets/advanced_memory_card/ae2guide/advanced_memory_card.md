---
navigation:
  parent: ae2:items-blocks-machines/items-blocks-machines-index.md
  title: Advanced Memory Card
  icon: advanced_memory_card:advanced_memory_card
categories:
 - tools
item_ids:
 - advanced_memory_card:advanced_memory_card
---

# Advanced Memory Card

<ItemImage id="advanced_memory_card:advanced_memory_card" scale="4" />

The Advanced Memory Card is an enhanced version of the standard [Memory Card](ae2:items-blocks-machines/memory_card.md) that provides powerful automated configuration tools for Applied Energistics 2. It simplifies repetitive configuration work and makes it easier to deploy the same settings across many devices.

Unlike the standard Memory Card, the Advanced Memory Card has two operating modes: **Copy Mode** and **Config Mode**.

## Crafting

<RecipeFor id="advanced_memory_card:advanced_memory_card" />

Craft one AE2 Memory Card together with one Logic Processor, one Calculation Processor, and one Engineering Processor in any arrangement.

## Basic Controls

- While holding the Advanced Memory Card, press **V** to switch between Copy Mode and Config Mode. The key can be changed in Controls.
- The item tooltip shows the current mode and status.
- In Copy Mode, **right-click the air** to perform a batch paste.

---

# Copy Mode

Copy Mode lets you copy the configuration from one device and apply it to every compatible device inside a selected rectangular area.

## Workflow

1. **Shift + right-click** an AE2 device to copy its configuration, the same as a normal Memory Card.
2. **Right-click** the first corner of the area to mark the starting position.
3. **Right-click** the opposite corner to mark the ending position.
4. **Right-click the air** to paste the stored configuration to all compatible devices inside the selected area.

## Features

- Supports selected areas up to **2048 blocks** in volume.
- Works with all AE2 block entities, including ME Interfaces, Storage Buses, Export Buses, and others.
- Works with AE2 parts installed on cables, including Annihilation Planes, Formation Planes, P2P Tunnels, and others.
- If the selected area is too large, an error is shown and the selection is reset.
- The selection is automatically cleared after the paste completes.

## Visual Indicators

The selected area is rendered in the world using colored outlines:

- **Red outline**: the starting position has been selected and the ending position is still needed.
- **White outline**: both positions have been selected and the area is defined.
- **Green outline**: the area is confirmed and ready to paste.
- While selecting an area, the block under the crosshair is highlighted in green.

---

# Config Mode (P2P Tunnel Management)

Config Mode is a centralized management tool for P2P Tunnels. It scans the AE2 network for P2P devices and provides a graphical interface for managing them.

## Opening Config Mode

While the card is in Config Mode, **right-click** any P2P Tunnel part on an AE2 network to open the P2P management screen.

## GUI Layout

The Config Mode screen has three main areas.

### Left Side: P2P Tree

- P2P devices are arranged in a three-level tree: **P2P Type → Frequency → P2P Device**.
- A colored dot shows the connection state of each P2P device:
  - **Green**: connected and active.
  - **Red**: not connected.
  - **Gray**: inactive.
- Blue arrows mark inputs and yellow arrows mark outputs.
- Purple bold text marks the P2P device currently waiting to be bound.
- The search box can filter by type, frequency, name, or alias.

### Right Side: Details

The information and available controls depend on the selected node.

**P2P Device**

- Shows the editable name, frequency, type, dimension, coordinates, direction, and connection state.
- ME P2P devices also show channel usage information.
- Controls include Rename, Select, Highlight, Locate, Assign New Frequency, and Refresh.

**Frequency**

- Shows the editable frequency alias, P2P count, channel information, and input/output counts.
- Controls include Rename, Bind, Highlight, Locate, and Refresh.

**P2P Type**

- Shows the type name, total P2P device count, and total frequency count.
- ME P2P types also provide an **Initialize P2P** control that automatically configures the input/output roles of unassigned ME P2P devices.

### Bottom

The bottom of the screen displays context-sensitive instructions, such as selecting a P2P node to view its details.

## Core Features

### P2P Device Binding

1. Select an unbound P2P device in the tree.
2. Click **Select** to mark it as the device waiting to be bound.
3. Select the target frequency.
4. Click **Bind** to bind the device to that frequency.

### Automatic ME P2P I/O Configuration

Using **Initialize P2P** on an ME P2P type automatically:

- Checks whether the network containing each ME P2P has an ME Controller.
  - A network with a controller is configured as an input.
  - A network without a controller is configured as an output.
- Assigns a new frequency to ME P2P devices that do not already have one.

### P2P Highlighting and Teleporting

- Clicking **Highlight** closes the GUI and renders colored outlines around the target devices for 5 seconds.
- Red marks the current target device.
- Green marks the input for the frequency.
- Blue marks the outputs for the frequency.
- A clickable teleport command is also sent to chat. Teleporting requires cheats or operator permission.

### Renaming

- P2P device nodes can be renamed to make devices easier to identify in large networks.
- Frequency nodes can be given aliases. This changes the name of the input P2P for that frequency.

### Assign New Frequency

For non-ME P2P devices, **Assign New Frequency**:

- Disconnects the current connection.
- Sets the device as an input.
- Assigns a new unique frequency.

---

# Compatible Devices

## Copy Mode

Copy Mode works with devices and parts that support AE2 Memory Card settings, including:

- ME Interface
- Storage Bus
- Import Bus and Export Bus
- Level Emitter
- Energy Acceptor
- Annihilation Plane and Formation Plane
- Molecular Assembler
- P2P Tunnel

## Config Mode

Config Mode supports all P2P Tunnel types on an AE2 network, including:

- ME P2P Tunnel
- Item P2P Tunnel
- Fluid P2P Tunnel
- Redstone P2P Tunnel
- Energy P2P Tunnel
- Light P2P Tunnel
- Other P2P types

---

The Advanced Memory Card reduces the time and effort needed to configure, maintain, and manage large AE2 networks and P2P setups.
