# 🍓 eper_me

A standalone, modern `/me` `/do` command script for FiveM, built for **QBCore**.
It replaces the default chat text with a clean, stylized 3D display above the player's head, matching the UI style of the **eper** collection.

![License](https://img.shields.io/badge/License-MIT-green.svg)
![Framework](https://img.shields.io/badge/Framework-QBCore-blue.svg)

## ✨ Features

* **💬 Visual Roleplay:** Displays `/me` `/do` actions directly above the character's head instead of just the chat box.
* **🎨 Modern UI:** Uses a custom, clean background and font style consistent with `eper` scripts.
* **📏 Dynamic Distance:** Text is only visible to nearby players to reduce screen clutter.
* **⏱️ Auto-Fade:** The message automatically fades out after a few seconds.
* **🚀 Optimized:** Extremely lightweight with 0.00ms resmon usage when idle.

## 📦 Dependencies

* [qb-core](https://github.com/qbcore-framework/qb-core)

## 🛠️ Installation

1.  **Download** the repository.
2.  **Rename** the folder to `eper_me`.
3.  **Drop** the folder into your server's `resources` directory.
4.  **Add** `ensure eper_me` to your `server.cfg`.
5.  **Restart** your server.


## ⚙️ Configuration

You can adjust the display time and visual distance in the code variables (e.g., `client.lua` or `config.lua`).

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---
**Created with ❤️ by [Eper]**