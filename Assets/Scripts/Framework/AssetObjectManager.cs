using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface; 

namespace Framework{

	public class AssetObjectManager : Singleton<AssetObjectManager>{  

		public delegate void LoadObjectCallback(int error,Object go);

		public virtual void LoadObject(AssetBundle bundle,LoadObjectCallback callback){
			StartCoroutine(LoadAssetObject(bundle,callback));
		} 

		private IEnumerator LoadAssetObject(AssetBundle bundle,LoadObjectCallback callback){
			var request = bundle.LoadAllAssetsAsync<Object> ();

			while (!request.isDone) {
				yield return request;
			} 
			if (request.asset!=null) {
				if (callback != null) { 
					callback (0,request.asset); 
				}
			} else {
				if (callback != null) {
					Debug.LogErrorFormat ("LoadAssetObject {0} null", bundle.name);
					callback (-1,null);
				}
			} 
			request = null;
		} 

	}
}


