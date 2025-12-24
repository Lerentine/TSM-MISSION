using Barotrauma;
using Barotrauma.Items.Components;
using FarseerPhysics.Dynamics;
using HarmonyLib;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;
using Color = Microsoft.Xna.Framework.Color;

namespace JiuzhouHint
{
    public class JiuzhouHint : IAssemblyPlugin
    {
        public readonly string Name = "Jiuzhou Hint";
        public static float HitHintTimer { get; set; }
        public static int HitHintSize { get; set; } = 10;
        public static Color HitHintColor { get; set; }
        public static int CrosshairDistance { get; set; } = 10;

        public static float IndicatorRadiusStart { get; set; } = 50.0f;
        public static float IndicatorThickness { get; set; } = 3.0f;
        public static float IndicatorSectionRad { get; set; } = 0.2222f * 2.0f * MathF.PI;
        public static float IndicatorRotationAngle { get; set; } = 0.1389f * 2.0f * MathF.PI;

        public Harmony? harmonyInstance;

        public void Initialize()
        {
            LuaCsLogger.Log($"Jiuzhou Hint loading...");
            harmonyInstance = new Harmony("Jiuzhou.Hint.Esirprus");
        }
        public void Dispose()
        {
            harmonyInstance?.UnpatchSelf();
            LuaCsLogger.Log("Jiuzhou Hint disposed!");
        }

        public void OnLoadCompleted()
        {
            if (true)
            {
                harmonyInstance.PatchAll();
                GameMain.LuaCs.Hook.Add("think", "UpdateJiuzhouHint", UpdateJiuzhouHint);
                LuaCsLogger.Log($"Jiuzhou Hint loaded!");
            }
            else
            {
                harmonyInstance = null;
                LuaCsLogger.Log($"Jiuzhou Hint has been disabled because other mod contains its function.");
            }
        }

        public void PreInitPatching()
        {
        }

        //patch ApplyAttack
        [HarmonyPatch(typeof(Character), nameof(Character.ApplyAttack))]
        public static class ApplyAttackPatch
        {
            public static void Postfix(Character __instance, Character attacker, AttackResult __result)
            {
                if (__instance == null || attacker == null || IsDefaultAttackResult(__result)) { return; }
                if (attacker == Character.Controlled)
                {
#if DEBUG
                    LuaCsLogger.Log($"{attacker.Name} attacked {__instance.Name}");
#endif
                    if (IsOutOfScreen(__instance.WorldPosition)) { return; }
                    HitHintTimer = 0.5f;
                }
            }
            private static bool IsOutOfScreen(Vector2 position)
            {
                if (Screen.Selected?.Cam == null) { return true; }
                bool result = position.X < Screen.Selected.Cam.WorldView.X
                              || position.X > Screen.Selected.Cam.WorldView.Right
                              || position.Y > Screen.Selected.Cam.WorldView.Y
                              || position.Y < Screen.Selected.Cam.WorldView.Y - Screen.Selected.Cam.WorldView.Height;
                return result;
            }
            private static bool IsDefaultAttackResult(AttackResult result)
            {
                return result.Damage == 0 && result.Afflictions == null && result.HitLimb == null && result.AppliedDamageModifiers == null;
            }
        }
        //dont use this it will cause game crash on subeditor
        ////patch UpdateHUDComponentSpecific
        //[HarmonyPatch(typeof(RangedWeapon), nameof(RangedWeapon.UpdateHUDComponentSpecific))]
        //public static class UpdateHUDComponentSpecificPatch
        //{
        //    public static void Postfix(float deltaTime)
        //    {
        //        HitHintTimer -= deltaTime;
        //        HitHintTimer = Math.Max(HitHintTimer, 0);
        //    }
        //}

        public static object[]? UpdateJiuzhouHint(object[]? args)
        {
            HitHintTimer -= (float)Timing.Step;
            HitHintTimer = Math.Max(HitHintTimer, 0);
            return null;
        }

        //patch DrawHUD
        [HarmonyPatch(typeof(RangedWeapon), nameof(RangedWeapon.DrawHUD))]
        static class RangedWeapon_DrawHUD_Patch
        {
            static IEnumerable<CodeInstruction> Transpiler(IEnumerable<CodeInstruction> instructions)
            {
                var codes = new List<CodeInstruction>(instructions);
                bool foundInsertionPoint = false;

                for (int i = 0; i < codes.Count; i++)
                {

                    if (codes[i].opcode == OpCodes.Ldarg_0 &&
                        codes[i + 1].opcode == OpCodes.Ldfld &&
                        codes[i + 1].operand.ToString().Contains("crossHairPosDirtyTimer"))
                    {

                        foundInsertionPoint = true;

                        var injectCode = new List<CodeInstruction>
                        {
                            new CodeInstruction(OpCodes.Ldarg_0),      // this (RangedWeapon)
                            new CodeInstruction(OpCodes.Ldarg_1),      // spriteBatch
                            new CodeInstruction(OpCodes.Call, typeof(JiuzhouHint).GetMethod("DrawHint"))
                        };

                        codes.InsertRange(i + 1, injectCode);
                        break;
                    }
                }

                if (!foundInsertionPoint)
                    throw new Exception("Failed to find insertion point in IL code! This may beacuse of other mod(s).");

                return codes;
            }

        }
        public static void DrawHint(RangedWeapon rangedWeapon, SpriteBatch spriteBatch)
        {
            var position = rangedWeapon.crosshairPos;
            HitHintColor = new Color(255, 255, 255, HitHintTimer > 0 ? 255 : 0);
            ShapeExtensions.DrawLine(spriteBatch,
                                     new Vector2(position.X + CrosshairDistance, position.Y + CrosshairDistance),
                                     new Vector2(position.X + CrosshairDistance + HitHintSize, position.Y + CrosshairDistance + HitHintSize),
                                     HitHintColor);
            ShapeExtensions.DrawLine(spriteBatch,
                                     new Vector2(position.X - CrosshairDistance, position.Y + CrosshairDistance),
                                     new Vector2(position.X - CrosshairDistance - HitHintSize, position.Y + CrosshairDistance + HitHintSize),
                                     HitHintColor);
            ShapeExtensions.DrawLine(spriteBatch,
                                     new Vector2(position.X + CrosshairDistance, position.Y - CrosshairDistance),
                                     new Vector2(position.X + CrosshairDistance + HitHintSize, position.Y - CrosshairDistance - HitHintSize),
                                     HitHintColor);
            ShapeExtensions.DrawLine(spriteBatch,
                                     new Vector2(position.X - CrosshairDistance, position.Y - CrosshairDistance),
                                     new Vector2(position.X - CrosshairDistance - HitHintSize, position.Y - CrosshairDistance - HitHintSize),
                                     HitHintColor);

            var ItemContainer = rangedWeapon.Item.GetComponent<ItemContainer>();
            if (ItemContainer == null) { return; }
            float containedIndicatorState = rangedWeapon.Item.GetComponent<ItemContainer>().GetContainedIndicatorState();
            if (containedIndicatorState == 0.0f) { return; }
            Color indicatorColor = ToolBox.GradientLerp(containedIndicatorState,
                                                        GUIStyle.ColorInventoryEmpty,
                                                        GUIStyle.ColorInventoryHalf,
                                                        GUIStyle.ColorInventoryFull);
            GUIExtensions.DrawDonutSectionOutLine(spriteBatch,
                                                  PlayerInput.MousePosition,
                                                  new Range<float>(IndicatorRadiusStart - 1.0f, IndicatorRadiusStart + IndicatorThickness + 1.0f),
                                                  IndicatorSectionRad,
                                                  Color.Gray,
                                                  0,
                                                  IndicatorRotationAngle);
            GUIExtensions.DrawDonutSection(spriteBatch,
                                              PlayerInput.MousePosition,
                                              new Range<float>(IndicatorRadiusStart, IndicatorRadiusStart + IndicatorThickness),
                                              containedIndicatorState * IndicatorSectionRad,
                                              indicatorColor,
                                              0,
                                              IndicatorRotationAngle + IndicatorSectionRad,
                                              false);


        }
    }

}

