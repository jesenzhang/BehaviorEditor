using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace BehaviorSystem.Editor{
	
	public class BehaviorEditorWindow : EditorWindow {

		[MenuItem("Window/BehaviorEditor",false,10)]
		public static void ShowBehaviorEditorWindow(){
			EditorWindow.GetWindow<BehaviorEditorWindow> ("Behavior Editor").ShowTab();
		}

		public void OnGUI(){
			DrawGirds ();
		}

		private void DrawGirds(){
			float width = 1000;
			float height = 1000;

			GL.Color (Color.red);
			GL.PushMatrix ();
			for (int i = 1; i <= 10; ++i) {
				GL.Begin (GL.LINES);
				GL.Vertex3 (0, i * height/10, 10);
				GL.Vertex3 (width, i * height/10, 0);
				GL.End ();
			}
			GL.PopMatrix ();
			GL.Flush ();
		}
	}
}


