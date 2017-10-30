namespace BehaviorDesigner.Runtime
{
    [System.Serializable]
    public class SharedFloat : SharedVariable<float>
    {
        public static implicit operator SharedFloat(float value) { return new SharedFloat { Value = value }; }

		public override void SetValue (object value)
    	{
			if (value is System.Double) {
				double v = (System.Double)value;
				value = (float)v;
			} 

			base.SetValue (value);
    	}
    }
}