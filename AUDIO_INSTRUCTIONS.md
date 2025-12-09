# Adding Audio to Loot-it-All: A Step-by-Step Guide (GitHub Desktop Version)

## **Objective**

This guide will walk you through adding background music and sound effects to the "Loot-it-All" game. By the end, you will have learned to:

1.  Create and manage a feature branch using **GitHub Desktop**.
2.  Find and import audio assets into a Godot project.
3.  Implement looping background music.
4.  Trigger 2D (non-spatial) and 3D (spatial) sound effects from game events.
5.  Write clean, maintainable GDScript to control audio playback using `@onready` variables.
6.  Complete a challenge to add a special audio reward.

---

## **Part 1: Create Your Development Branch (Using GitHub Desktop)**

Before writing any code, create a new branch to contain your work. This keeps the main version of the game stable.

1.  In GitHub Desktop, make sure your "Current Repository" is set to `M05-SY2526-Loot-it-All`.
2.  At the top of the screen, click the **Current Branch** button (it will likely say `main`).
3.  Click the blue **New Branch** button.
4.  In the pop-up window, name your new branch `feature/add-audio`.
5.  Click **Create Branch**. You will automatically be switched to your new branch.
6.  Finally, click the **Publish branch** button that appears at the top. This makes your branch visible on GitHub and is good practice.

You are now ready to start making changes on your own branch!

---

## **Part 2: Find and Organize Audio Files**

You will need several audio files. Good sources for free, high-quality audio are [FreeSound.org](https://freesound.org/) and [Pixabay Music](https://pixabay.com/music/).

**Sounds to find:**
*   **Background Music:** A looping sci-fi or ambient track.
*   **Gem Pickup:** A short, satisfying "bling" or "chime".
*   **Health Pickup:** A "power-up" or "heal" sound.
*   **Ship Thruster:** A low hum or rocket burn that can be looped seamlessly.
*   **Bonus Sound:** A special, exciting sound for the challenge.

**Action:**
1.  In your project folder, create a new subfolder: `assets/audio`.
2.  Download your chosen audio files (using `.ogg` is recommended for performance) and place them in this new folder.

---

## **Part 3: Implementation**

*(These steps are performed in the Godot Editor)*

### **3.1. Background Music**
1.  Open `lessons/space_level.tscn`.
2.  Add a new **AudioStreamPlayer** node and rename it `MusicPlayer`.
3.  In the Inspector, drag your music file to the **Stream** property and check **Autoplay**.
4.  In the FileSystem dock, double-click your music file, go to the **Import** tab, check **Loop**, and click **Reimport**.

### **3.2. Ship Thruster Sound**
1.  Open `lessons/ship.tscn`.
2.  Add an **AudioStreamPlayer** node and rename it `ThrusterSoundPlayer`.
3.  Assign your thruster sound to its **Stream** property.
4.  In the FileSystem, select the thruster audio file, go to the **Import** tab, check **Loop**, and click **Reimport**.
5.  Open `lessons/ship.gd`. Add the `@onready` variable and modify the `_process` function:

    ```gdscript
    extends Area2D
    
    @onready var thruster_sound_player: AudioStreamPlayer = $ThrusterSoundPlayer
    // ... rest of variables

    func _process(delta: float) -> void:
        var direction := Vector2(0, 0)
        direction.x = Input.get_axis("move_left", "move_right")
        direction.y = Input.get_axis("move_up", "move_down")

        var is_moving := direction.length() > 0.0
        if is_moving and not thruster_sound_player.playing:
            thruster_sound_player.play()
        elif not is_moving and thruster_sound_player.playing:
            thruster_sound_player.stop()
        // ... rest of function
    ```

### **3.3. Item Pickup Sounds**
**1. Add Audio Nodes:**
*   **Gem:** Open `lessons/gem.tscn`, add an **AudioStreamPlayer**, and assign its stream.
*   **Health Pack:** Open `lessons/health_pack.tscn`, add an **AudioStreamPlayer3D**, and assign its stream.

**2. Assign Groups:**
*   **Ship:** In `lessons/ship.tscn`, add the root node to the `player` group.
*   **Gem:** In `lessons/gem.tscn`, add the root node to the `gem` group.
*   **Health Pack:** In `lessons/health_pack.tscn`, add the root node to the `healing_item` group.

**3. Modify the Item Script:**
Replace the entire contents of `lessons/item.gd` with this code:
```gdscript
extends Area2D

@onready var sfx_player: AudioStreamPlayer = find_child("AudioStreamPlayer") or find_child("AudioStreamPlayer3D")

func _on_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	visible = false

	if sfx_player:
		sfx_player.play()
		await sfx_player.finished
	
	queue_free()

func _ready() -> void:
	area_entered.connect(_on_area_entered)
```

---

## **Part 4: The Challenge!**

**Goal:** Play a special sound every 10 gems.

1.  In `lessons/ship.tscn`, add an **AudioStreamPlayer** and rename it `BonusSoundPlayer`. Assign its stream.
2.  Open `lessons/ship.gd` and add the logic:

    ```gdscript
    extends Area2D
    
    @onready var thruster_sound_player: AudioStreamPlayer = $ThrusterSoundPlayer
    @onready var bonus_sound_player: AudioStreamPlayer = $BonusSoundPlayer
    // ... rest of variables

    // ... other functions

    func set_gem_count(new_gem_count: int) -> void:
        gem_count = new_gem_count
        get_node("Control/GemCount").text = "x" + str(gem_count)
        
        if gem_count > 0 and gem_count % 10 == 0:
            bonus_sound_player.play()
    ```

---

## **Part 5: Finalizing Your Work (Using GitHub Desktop)**

Once everything is working, it's time to merge your feature into the main branch.

1.  **Commit Your Changes:** In GitHub Desktop, you will see all your changed files. In the bottom-left corner:
    *   Write a clear summary message (e.g., `feat: Add audio effects and music`).
    *   Write an optional description if needed.
    *   Click the blue **Commit to feature/add-audio** button.

2.  **Switch to the Main Branch:** Click on **Current Branch** at the top and select `main` from the list.

3.  **Merge Your Branch:**
    *   Go to the top menu bar and click **Branch** -> **Merge Into Current Branch...**.
    *   A window will pop up. Select the `feature/add-audio` branch from the list to merge it into `main`.
    *   Click the **Merge** button. Your feature is now part of the `main` branch on your computer.

4.  **Push to GitHub:** Finally, click the **Push origin** button at the top. This uploads your merged changes from `main` to the shared GitHub repository.