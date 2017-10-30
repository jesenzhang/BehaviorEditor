using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using LuaInterface; 

namespace Framework{ 

	public class SceneManager : Singleton<SceneManager>{   

		internal class LoadResult{
			public bool value;

			public LoadResult(bool value){
				this.value = value;
			}
		}

		public delegate void LoadSceneCallback(int error,string go);

		public virtual void LoadScene(AssetBundle bundle,LoadSceneCallback callback){
			StartCoroutine(LoadBundleScene(bundle,callback));
		} 

		public virtual void LoadSceneByName(string name,LoadSceneCallback callback){ 
			StartCoroutine(LoadBundleScene(name,callback));
		} 

		private IEnumerator LoadBundleScene(string path,LoadSceneCallback callback){
			var request = new WWW (path.StartsWith("jar:")?path:"file:///"+path);   

			while (!request.isDone) {
				if (string.IsNullOrEmpty (request.error)) {
					yield return request;
				} else {
					break;
				}
			}

			if (string.IsNullOrEmpty (request.error)) {
				var bundle = request.assetBundle;
				var sceneName = bundle.GetAllScenePaths ()[0];
				var op = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync (sceneName); 

				yield return op;

				//while (!op.isDone) { 
				//	yield return new WaitForEndOfFrame();
				//}

				Debug.LogError ("loaded "+sceneName);

				if (callback != null) {
					callback (0,sceneName);
				}

				bundle.Unload (true);

			} else {
				if (callback != null) {
					Debug.LogErrorFormat ("LoadBundleScene {0} error with {1}", path, request.error);
					callback (-1,path);
				}
			}

			request.Dispose ();
			request = null;
		}

		private IEnumerator LoadBundleScene(AssetBundle bundle,LoadSceneCallback callback){
			var sceneName = bundle.GetAllScenePaths ()[0];

			var op = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync (sceneName);

			LoadResult loaded = new LoadResult(op.isDone);

			UnityAction<UnityEngine.SceneManagement.Scene, UnityEngine.SceneManagement.LoadSceneMode> func = delegate(UnityEngine.SceneManagement.Scene arg0, UnityEngine.SceneManagement.LoadSceneMode arg1) {
				if (arg0.name.ToLower().Equals(bundle.name))
					loaded.value = true; 

				print(arg0.name.ToLower()+","+bundle.name+","+loaded+","+op.isDone);
			};

			UnityEngine.SceneManagement.SceneManager.sceneLoaded += func;

			while (!loaded.value) {
				Debug.LogError ("loaded"+loaded.value);
				yield return new WaitForEndOfFrame();
			}

			UnityEngine.SceneManagement.SceneManager.sceneLoaded -= func;

			Debug.LogError ("loaded "+sceneName);

			if (callback != null) {
				callback (0,sceneName);
			}

			bundle.Unload (true);
		} 

	}
}


