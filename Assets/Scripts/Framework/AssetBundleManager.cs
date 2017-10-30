using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace Framework{

	public class AssetBundleManager : Singleton<AssetBundleManager>  { 

		public delegate void LoadBundleCallback(int error,AssetBundle bundle);  

		public virtual void LoadAssetBundle(string path,LoadBundleCallback callback){
			StartCoroutine(LoadWWWBundle(path,callback));
		}		 

		private IEnumerator LoadWWWBundle(string path,LoadBundleCallback callback){
			var request = new WWW (path.StartsWith("jar:")?path:"file:///"+path);   

			while (!request.isDone) {
				if (string.IsNullOrEmpty (request.error)) {
					yield return request;
				} else {
					break;
				}
			}

			if (string.IsNullOrEmpty (request.error)) {
				if (callback != null) {
					callback (0,request.assetBundle);
				}
			} else {
				if (callback != null) {
					Debug.LogErrorFormat ("LoadWWWBundle {0} error with {1}", path, request.error);
					callback (-1,null);
				}
			}

			request.Dispose ();
			request = null;
		}
		 
	}
}


