using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace Framework{

	public class BytesManager : Singleton<BytesManager>  { 
		 
		public delegate void LoadDataCallback(int error,byte[] data);

		public virtual void LoadData(string path,LoadDataCallback callback){
			StartCoroutine(LoadWWWData(path,callback));
		}

		public virtual void LoadData(string path,LuaFunction func){
			StartCoroutine(LoadWWWData(path,delegate(int error,byte[] data) { 
				func.Call(error,new LuaByteBuffer(data));
			}));
		}

		private IEnumerator LoadWWWData(string path,LoadDataCallback callback){
			var request = new WWW (path.StartsWith("jar:")?path:"file:///"+path);   
			 
			while (!request.isDone) { 
				if (string.IsNullOrEmpty (request.error)) {
					yield return null;
				} else {
					break;
				}
			}

			if (string.IsNullOrEmpty (request.error)) {
				if (callback != null) {
					callback (0,request.bytes);
				}
			} else {
				if (callback != null) { 
					Debug.LogErrorFormat ("LoadWWWData {0} error with {1}", path, request.error);
					callback (-1,null);
				}
			}
		}
	}
}


