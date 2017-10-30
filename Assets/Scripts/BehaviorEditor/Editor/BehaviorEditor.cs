using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using BehaviorDesigner;
using BehaviorDesigner.Runtime;
using BehaviorDesigner.Editor; 
using System.IO;

public class BehaviorEditor  {
	[MenuItem("Tools/Export Behavior Tree")]
	static void ExportBehaviorTree(){
		var trees = Selection.GetFiltered<BehaviorTree> (SelectionMode.TopLevel);
		foreach (var tree in trees) {			
			BehaviorExportHelper.ExportBehaviorTree (tree);
		}
	}

	//[MenuItem("Tools/Export Behavior Icons")]
	private static void ExportAllDLLTextures(){ 
		ExportTexture ("TaskEnableIcon.png"); 
		ExportTexture ("ExecutionFailure.png");
		ExportTexture ("ExecutionSuccess.png");
		ExportTexture ("TaskBorderRunning.png",true);  
		ExportTexture ("TaskRunning.png",true);  
	}

	private static void ExportTexture(string path,bool skin=false){
		var icon = BehaviorDesignerUtility.LoadTexture (path,skin);
		if (icon != null) {  
			//icon.Resize (16, 16, TextureFormat.ARGB32, false);
			var data = icon.EncodeToPNG (); 
			File.WriteAllBytes ("Assets/DebugSystem/Icons/" + path, data);
			AssetDatabase.Refresh ();
		}
	}
	 
}
