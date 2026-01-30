using UnityEngine;
using CustomGenerator.Utility;

namespace CustomGenerator
{
    internal class HarmonyModHooks : IHarmonyModHooks
    {
        void IHarmonyModHooks.OnLoaded(OnHarmonyModLoadedArgs args) {
            Debug.Log("[Harmony] Loaded: CustomGenerator");

            // Initialize plugin - moved from Bootstrap.StartupShared patch
            // to avoid MissingFieldException with skipAssetWarmup_crashes
            Logging.StartingMessage();

            Rust.Ai.AiManager.nav_disable = true;
            Rust.Ai.AiManager.nav_wait = false;

            Logging.ClearOldLogs();
        }

        void IHarmonyModHooks.OnUnloaded(OnHarmonyModUnloadedArgs args) {
            Debug.Log("[Harmony] Unloaded: CustomGenerator");
        }
    }
}
