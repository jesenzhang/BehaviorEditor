using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Framework{
	public class Singleton<T> : MonoBehaviour where T:MonoBehaviour {
		private static T _instance;

		public static T instance{
			get { 
				if (_instance == null) {
					_instance = GameObject.FindObjectOfType<T> ();
					if (_instance == null) {
						var go = new GameObject (typeof(T).Name);
						_instance = go.AddComponent<T> ();
					}
				}
				return _instance;
			}
		}

		protected virtual void OnDestroy(){
			if (_instance == this) {
				_instance = null;
			}
		}
	}
}
