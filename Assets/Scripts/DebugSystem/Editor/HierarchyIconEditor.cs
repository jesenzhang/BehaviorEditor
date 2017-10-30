using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;



namespace DebugSystem{
	[InitializeOnLoad]
	public class HierarchyIconEditor  : ScriptableObject{

		private static Dictionary<string,Texture> textureCache = new Dictionary<string,Texture>();

		static HierarchyIconEditor ()
		{
			EditorApplication.hierarchyWindowItemOnGUI += HierarchyWindowItemOnGUI;
		}

		 
		private static void HierarchyWindowItemOnGUI (int instanceID, Rect selectionRect)
		{
			
			GameObject gameObject = EditorUtility.InstanceIDToObject (instanceID) as GameObject;
			if (gameObject != null && gameObject.GetComponent<DebugGameObjectComponent> () != null) { 
				var go = gameObject.GetComponent<DebugGameObjectComponent> ();
				if (!string.IsNullOrEmpty (go.icon)) {					
					var icon = GetOrCreateTexture (go.icon);
					if (icon != null) {
						Rect rect = new Rect (selectionRect); 
						switch (go.iconLayout) {
						case DebugGameObjectComponent.IconLayout.FILL:  
							{
								GUI.DrawTexture (rect,icon);
							}
							break;
						case DebugGameObjectComponent.IconLayout.RIGHT: 
						default:
							{
								rect.x = rect.width + (selectionRect.x - 16); 
								rect.y = rect.height + (selectionRect.y - 16); 
								rect.width = 16;
								rect.height = 16;
								GUI.DrawTexture (rect,icon);
							}
							break;
						}
					}
				}
			}
		}

		private static Texture GetOrCreateTexture(string path){
			Texture tex = null;
			if (!textureCache.TryGetValue (path, out tex)) {
				tex = AssetDatabase.LoadAssetAtPath<Texture> ("Assets/DebugSystem/Icons/"+path+".png");  
				textureCache.Add (path, tex);
					
			}
			return tex;
		} 

	}
}


