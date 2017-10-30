DebugGameObject = class("DebugGameObject",nil)

DebugGameObject.ICON_LAYOUT_RIGHT = 1;
DebugGameObject.ICON_LAYOUT_FILL = 2;

function DebugGameObject:ctor(parent,name)
    self._parent = parent;
    self._name = name;
    self._go = nil;
    self._debug = nil;
    self._watcher = nil;
    self._active = true;
end

function DebugGameObject:Init()
    --print("DebugGameObject:Init",self._name)
    self._go = UnityEngine.GameObject.New(self._name);
    self._debug = self._go:AddComponent(typeof(DebugSystem.DebugGameObjectComponent));
    self._watcher = self._go:AddComponent(typeof(DebugSystem.GameDebugWatcherComponent));

    if self._parent then
        self._go.transform.parent = self._parent._go.transform;
    end    
    if not self._active then
        self._go:SetActive(false);
    end
end

function DebugGameObject:SetWatcher(who)
    if self._watcher then
        self._watcher.self = who;
    end
end

function DebugGameObject:SetName(name) 
    self._name = name;
    if self._go then
        self._go.name = name;
    end
end

function DebugGameObject:SetParent(parent)
    self._parent = parent;    
    if self._go then
        if self._parent then
            self._go.transform.parent = self._parent._go.transform;
        else
            self._go.transform.parent = nil;
        end
    end
end

function DebugGameObject:SetParentTransform(parent) 
    if self._go then
        self._go.transform.parent = parent;
    end
end

function DebugGameObject:SetIcon(icon,layout)
    if self._debug then
        self._debug.icon = icon;
        if layout then
            self._debug.iconLayout = DebugSystem.DebugGameObjectComponent.IconLayout.IntToEnum(layout);
        else
            self._debug.iconLayout = DebugSystem.DebugGameObjectComponent.IconLayout.RIGHT;
        end
    end
end

function DebugGameObject:SetPosition(pos)
    if self._go then
        self._go.transform.position = pos;
    end
end

function DebugGameObject:SetSize(size)
    if self._go then
        self._go.transform.localScale = size;
    end
end

function DebugGameObject:SetActive(active)
    if self._active ~= active then
        self._active = active;
        if self._go then
            self._go:SetActive(active);
        end
    end   
end

function DebugGameObject:Destroy()
    if self._go then
        UnityEngine.GameObject.Destroy(self._go)
        self._go = nil;
    end
end


return DebugGameObject;