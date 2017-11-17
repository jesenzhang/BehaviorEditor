using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using System; 

namespace Framework{

	public class GameScriptManager : Singleton<GameScriptManager> { 
		private LuaState _luaState;

		void Awake(){
			if (LuaClient.Instance == null) {
				gameObject.AddComponent<LuaClient> ();
			}
			_luaState = LuaClient.GetMainState ();
			GameObject.DontDestroyOnLoad (gameObject); 

			_luaState.Call ("RunGame",false);
		}

		protected override void OnDestroy(){
			_luaState = null;
			base.OnDestroy ();
		}

		public void Init(){
			#if UNITY_EDITOR 
			AddSearchPath (LuaConst.luaDir+"/Proto");
			#endif
			AddSearchPath(LuaConst.luaResDir+"/Proto");
		}

		public void AddSearchPath(string path){
			Debug.LogFormat ("AddSearchPath {0}",path);
			_luaState.AddSearchPath (path);
		}
		 

		public LuaTable Require(string scriptName){
			LuaTable ret = null;
			try{
				ret = _luaState.Require<LuaTable> (scriptName);  
			}catch(Exception e){ 
				Debug.LogException (e);
			}
			return ret;
		}

		public LuaTable DoFile(string scriptName){
			LuaTable ret = null;
			try{
				ret = _luaState.DoFile<LuaTable> (scriptName);  
			}catch(Exception e){ 
				Debug.LogException (e);
			}
			return ret;
		}

		public bool CallVoidFunc(string name){ 
			bool ret = false;
			try{
				_luaState.Call(name,true);
				ret = true;
			}catch(Exception e){ 
				Debug.LogException (e);
			} 
			return ret;
		}

		public R1 CallFunc<R1>(string name,R1 defaultValue){
			R1 ret = defaultValue;
			try{
				ret = _luaState.Invoke<R1>(name,true);
			}catch(Exception e){ 
				Debug.LogException (e);
			}
			return ret;
		}

		public void SetTable(string name,LuaTable t){
			_luaState [name] = t;
		}

		public void SetUserData(string name,object t){
			_luaState [name] = t;
		}

		public object GetTableField(LuaTable self, string fieldName){

			object ret = null;
			try{
				ret = self[fieldName];
			}catch(Exception e){ 
				ret = e.Message;
				//Debug.LogException (e);
			}
			return ret; 
		} 

		public object ExecuteTableMethod(LuaTable self, string methodName){

			object ret = null;
			try{
				ret = self.Invoke<LuaTable,object>(methodName,self);
			}catch(Exception e){ 
				ret = e.Message;
				//Debug.LogException (e);
			}
			return ret; 
		} 

		public object ExecuteString(string code){

			object ret = null;
			try{
				ret = _luaState.DoString<object> (code);
			}catch(Exception e){ 
				ret = e.Message;
				//Debug.LogException (e);
			}
			return ret; 
		} 
	}
}
