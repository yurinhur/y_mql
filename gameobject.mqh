//FEITO EM MQL5

//+------------------------------------------------------------------+
//|                                                       GameObject |
//|                                         Copyright 2022, Yuri EV. |
//|                              https://www.facebook.com/yuriemoff/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Yuri EV."
#property link      "https://www.facebook.com/yuriemoff/"

#include <VirtualKeys.mqh>
#include <WinAPI\\winuser.mqh>
#include <Canvas\Canvas.mqh>
#include <Canvas\CImage\CImage.mqh>

#define VK_A 0x41
#define VK_B 0x42
#define VK_C 0x43
#define VK_D 0x44
#define VK_E 0x45
#define VK_F 0x46
#define VK_G 0x47
#define VK_H 0x48
#define VK_I 0x49
#define VK_J 0x4A
#define VK_K 0x4B
#define VK_L 0x4C
#define VK_M 0x4D
#define VK_N 0x4E
#define VK_O 0x4F
#define VK_P 0x50
#define VK_Q 0x51
#define VK_R 0x52
#define VK_S 0x53
#define VK_T 0x54
#define VK_U 0x55
#define VK_V 0x56
#define VK_W 0x57
#define VK_X 0x58
#define VK_Y 0x59
#define VK_Z 0x5A

#define INVALID_VALUE -276447232

enum type_FPS
  {
   _60, //60
   _30, //30
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double FixedDeltaTime(void)
  {
   return(0.0152);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UI
  {
public:
   int               fontsize_fps;
   string            style_font_fps;
   type_FPS          fps;

public:
   long              chart(void);
   void              Draw(void);
   bool              ShowFPS(void);
   void              HideFPS(void);
   bool              TimeFPS(type_FPS type);
   int               Width(void);
   int               Height(void);
   void              FullScreen(void);
   void              WideScreen(void);
   bool              InMaxWidth(void);

private:
   int               count_fps;
   int               count_draw;
   int               sec_actual;
   int               max_width;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long UI::chart(void)
  {

   return(ChartID());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UI::Draw(void)
  {
   if(fps == _60)
     {
      ChartRedraw(ChartID());
      count_fps++;
     }
   else
      if(fps == _30)
        {
         if(count_draw >= 1)
           {
            ChartRedraw(ChartID());
            count_draw = 0;
            count_fps++;
           }
         else
            count_draw+=1;
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UI::InMaxWidth(void)
  {
   return(Width() == max_width ? true : false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UI::ShowFPS(void)
  {

   MqlDateTime time;

   TimeToStruct(TimeLocal(),time);

   if(time.sec != sec_actual)
      ObjectDelete(ChartID(),"LabelFPS"+_Symbol);
   else
      return(false);

   if(ObjectFind(ChartID(),"LabelFPS"+_Symbol) < 0)
     {
      ObjectCreate(ChartID(),"LabelFPS"+_Symbol,OBJ_LABEL,0,0,0);
      ObjectSetInteger(ChartID(),"LabelFPS"+_Symbol,OBJPROP_ANCHOR,ANCHOR_LEFT);
      ObjectSetInteger(ChartID(),"LabelFPS"+_Symbol,OBJPROP_XDISTANCE,5);
      ObjectSetInteger(ChartID(),"LabelFPS"+_Symbol,OBJPROP_YDISTANCE,30);
      ObjectSetInteger(ChartID(),"LabelFPS"+_Symbol,OBJPROP_FONTSIZE,fontsize_fps);
      ObjectSetString(ChartID(),"LabelFPS"+_Symbol,OBJPROP_FONT,style_font_fps);
      ObjectSetString(ChartID(),"LabelFPS"+_Symbol,OBJPROP_TEXT,"FPS: 20");
      ObjectSetInteger(ChartID(),"LabelFPS"+_Symbol,OBJPROP_COLOR,ChartGetInteger(ChartID(),CHART_COLOR_FOREGROUND,0));
     }

   if(time.sec != sec_actual)
     {
      sec_actual = time.sec;
      if(fps == _60 && count_fps > 60)
         ObjectSetString(ChartID(),"LabelFPS"+_Symbol,OBJPROP_TEXT,"FPS: 60");
      else
         if(fps == _30 && count_fps > 30)
            ObjectSetString(ChartID(),"LabelFPS"+_Symbol,OBJPROP_TEXT,"FPS: 30");
         else
            ObjectSetString(ChartID(),"LabelFPS"+_Symbol,OBJPROP_TEXT,"FPS: "+string(count_fps));

      count_fps = 0;
     }

   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UI::HideFPS(void)
  {
   ObjectDelete(ChartID(),"LabelFPS");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UI::TimeFPS(type_FPS type)
  {
   switch(type)
     {
      case _60:
         fps = _60;
         return(EventSetMillisecondTimer(1));
      case _30:
         fps = _30;
         return(EventSetMillisecondTimer(10));
     }

   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int UI::Width(void)
  {
   return(int(ChartGetInteger(chart(),CHART_WIDTH_IN_PIXELS)));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int UI::Height(void)
  {
   return(int(ChartGetInteger(chart(),CHART_HEIGHT_IN_PIXELS)));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UI::FullScreen(void)
  {
   ChartSetInteger(chart(),CHART_IS_DOCKED,false);

   max_width = int(ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS,0));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UI::WideScreen(void)
  {
   ChartSetInteger(chart(),CHART_IS_DOCKED,true);

   Sleep(100);
  }

//+------------------------------------------------------------------+
//|                       Object Class                               |
//+------------------------------------------------------------------+
class Object
  {

public:
   int size_x,
       size_y;

   double pos_x,
          pos_y;

   double            angle_to_dir;

   int               direction;

   double gravity,
          mass,
          speed_object;

   string            name;

   long              chart;

public:
   bool              CreateObject(const int subwindow);
   bool              CreateRectangle(color colorRectangle);
   bool              CreateCollider(color clrCollider, int sizex, int sizey);
   bool              MoveObject(const int subwindow, int posx, int posy);
   void              MoveObjectLinear(int objective_x, int objective_y, int speed_linear, bool comment_st);
   bool              SetSpriteObject(const string sprite_bitmap);
   bool              SetSpriteObjectAs(const uint &sprite[]);
   bool              BasicsEvents(void);
   bool              Destroy(void);
   bool              ModifyObject(int posx, int posy, int sizex, int sizey);
   void              SetLoopSprites(const string &sprites[], const double speed_sprite);
   bool              ResourceCreateForOBJ(const uint &resource[], const string name_resource, int x_size, int y_size);
   bool              IsCollider(Object &object_collider);
   bool              IsCollider(int posx, int posy, int sizex, int sizey);
   bool              IsExist(void);

   void              DestroyAllInstances(void);

   int               TotalsInstances(void);

private:
   string            bitmap_state;
   int               pos_x_ant, pos_y_ant;
   int               objective_x_ant, objective_y_ant;
   int               interval_x, interval_y, interval_x_ant, interval_y_ant;
   string            sprites_actual[2];

   bool              collider_exist;
   int               size_x_col, size_y_col;

public:
   double            count_sprites;
   string            sprite_actual;
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::IsExist(void)
  {
   return(ObjectFind(chart,name) >= 0 ? true : false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::IsCollider(Object &object_collider)
  {

   if(!collider_exist)
     {
      if(pos_x+size_x/2 >= object_collider.pos_x-object_collider.size_x/2 && pos_x-size_x/2 <= object_collider.pos_x+object_collider.size_x/2
         && pos_y+size_y/2 >= object_collider.pos_y-object_collider.size_y/2 && pos_y-size_y/2 <= object_collider.pos_y+object_collider.size_y/2)
         return(true);
     }
   else
     {
      if(pos_x+size_x_col/2 >= object_collider.pos_x-object_collider.size_x/2 && pos_x-size_x_col/2 <= object_collider.pos_x+object_collider.size_x/2
         && pos_y+size_y_col/2 >= object_collider.pos_y-object_collider.size_y/2 && pos_y-size_y_col/2 <= object_collider.pos_y+object_collider.size_y/2)
         return(true);
     }

   return(false);
  }

bool Object::IsCollider(int posx,int posy, int sizex, int sizey)
  {
   if(pos_x+size_x/2 >= posx-sizex/2 && pos_x-size_x/2 <= posx+sizex/2
      && pos_y+size_y/2 >= posy-sizey/2 && pos_y-size_y/2 <= posy+sizey/2)
      return(true);
   
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::BasicsEvents()
  {
   if(pos_x_ant != pos_x || pos_y_ant != pos_y)
     {
      pos_x_ant = (int)pos_x;
      pos_y_ant = (int)pos_y;

      MoveObject(0,pos_x_ant,pos_y_ant);
     }

   if(pos_x != ObjectGetInteger(ChartID(),name,OBJPROP_XDISTANCE) || pos_y != ObjectGetInteger(ChartID(),name,OBJPROP_YDISTANCE))
     {
      pos_x = (double)ObjectGetInteger(ChartID(),name,OBJPROP_XDISTANCE);
      pos_y = (double)ObjectGetInteger(ChartID(),name,OBJPROP_YDISTANCE);
      pos_x_ant = (int)pos_x;
      pos_y_ant = (int)pos_y;
     }

   if(ObjectFind(chart,name+"Apparence") >= 0)
     {

      if(ObjectGetInteger(chart,name,OBJPROP_ANCHOR) == ANCHOR_LEFT)
        {
         ObjectSetInteger(chart,name+"Apparence",OBJPROP_XDISTANCE,(int)pos_x);
         ObjectSetInteger(chart,name+"Apparence",OBJPROP_YDISTANCE,(int)pos_y-size_y/2);
        }
      else
        {
         ObjectSetInteger(chart,name+"Apparence",OBJPROP_XDISTANCE,(int)pos_x-size_x/2);
         ObjectSetInteger(chart,name+"Apparence",OBJPROP_YDISTANCE,(int)pos_y-size_y/2);
        }

      ObjectSetInteger(chart,name+"Apparence",OBJPROP_XSIZE,size_x);
      ObjectSetInteger(chart,name+"Apparence",OBJPROP_YSIZE,size_y);
     }

   if(collider_exist)
     {
      ObjectSetInteger(chart,name+"Collider",OBJPROP_XDISTANCE,(int)ObjectGetInteger(ChartID(),name,OBJPROP_XDISTANCE,0));
      ObjectSetInteger(chart,name+"Collider",OBJPROP_YDISTANCE,(int)ObjectGetInteger(ChartID(),name,OBJPROP_YDISTANCE,0));
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::CreateObject(const int subwindow)
  {
   if(!ObjectCreate(chart,name,OBJ_BITMAP_LABEL,subwindow,0,0))
      Print("Error Create Object: "+string(GetLastError()));

   ObjectSetInteger(chart,name,OBJPROP_XDISTANCE,(int)pos_x);
   ObjectSetInteger(chart,name,OBJPROP_YDISTANCE,(int)pos_y);
   ObjectSetInteger(chart,name,OBJPROP_XSIZE,size_x);
   ObjectSetInteger(chart,name,OBJPROP_YSIZE,size_y);
   ObjectSetInteger(chart,name,OBJPROP_XOFFSET,0);
   ObjectSetInteger(chart,name,OBJPROP_YOFFSET,0);
   ObjectSetInteger(chart,name,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(chart,name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart,name,OBJPROP_ANCHOR,ANCHOR_CENTER);
   ObjectSetInteger(chart,name,OBJPROP_BACK,false);
   ObjectSetInteger(chart,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chart,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chart,name,OBJPROP_HIDDEN,false);
   ObjectSetInteger(chart,name,OBJPROP_ZORDER,0);

   collider_exist = false;

   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::CreateCollider(color clrCollider, int sizex, int sizey)
  {
   if(!ObjectCreate(chart,name+"Collider",OBJ_BITMAP_LABEL,0,0,0))
     {
      Print("Error Create Collider: "+string(GetLastError()));
      return(false);
     }

   collider_exist = true;

   size_x_col = sizex;
   size_y_col = sizey;

   ObjectSetInteger(chart,name+"Collider",OBJPROP_XDISTANCE,(int)pos_x);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_YDISTANCE,(int)pos_y);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_XSIZE,sizex);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_YSIZE,sizey);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_XOFFSET,0);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_YOFFSET,0);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_COLOR,clrCollider);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_ANCHOR,ObjectGetInteger(chart,name,OBJPROP_ANCHOR));
   ObjectSetInteger(chart,name+"Collider",OBJPROP_BACK,false);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_SELECTED,false);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_HIDDEN,false);
   ObjectSetInteger(chart,name+"Collider",OBJPROP_ZORDER,0);

   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::CreateRectangle(color colorRectangle)
  {
   if(!ObjectCreate(chart,name+"Apparence",OBJ_RECTANGLE_LABEL,0,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }

   ObjectSetInteger(chart,name,OBJPROP_COLOR,colorRectangle);

   ObjectSetInteger(chart,name+"Apparence",OBJPROP_XDISTANCE,(int)pos_x-size_x/2);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_YDISTANCE,(int)pos_y-size_y/2);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_XSIZE,size_x);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_YSIZE,size_y);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_BGCOLOR,colorRectangle);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_XOFFSET,0);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_YOFFSET,0);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_BACK,false);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_SELECTED,false);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_HIDDEN,false);
   ObjectSetInteger(chart,name+"Apparence",OBJPROP_ZORDER,0);

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::MoveObject(const int subwindow,int posx,int posy)
  {
   bool retorno=false;

   if(ObjectSetInteger(chart,name,OBJPROP_XDISTANCE,posx))
      retorno=true;
   else
      retorno=false;

   if(ObjectSetInteger(chart,name,OBJPROP_YDISTANCE,posy))
      retorno=true;
   else
      retorno=false;

   return(retorno);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::SetSpriteObject(const string sprite_bitmap)
  {
   bool retorno=false;

   if(ObjectFind(chart,name) >= 0)
     {
      if(!ObjectSetString(chart,name,OBJPROP_BMPFILE,0,sprite_bitmap))
        {
         Print(__FUNCTION__,
               ": não deu para carregar a imagem = ",GetLastError());
         return(false);
        }
      else
         retorno=true;

      if(!ObjectSetString(chart,name,OBJPROP_BMPFILE,1,sprite_bitmap))
        {
         Print(__FUNCTION__,
               ": não deu para carregar a imagem = ",GetLastError());
         return(false);
        }
      else
         retorno=true;
     }

   bitmap_state = sprite_bitmap;
   sprite_actual = sprite_bitmap;

   count_sprites = 0;

   return(retorno);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::SetSpriteObjectAs(const uint &sprite[])
  {
   bool retorno=false;

   string sprite_bitmap_on, sprite_bitmap_off;

   uint MyPictureOn[], MyPictureOff[];

   ArrayCopy(MyPictureOn,sprite,0,0,WHOLE_ARRAY);

   ulong pattern=(ulong(clrWhite)<<8)+255;

   int size=ArraySize(MyPictureOn);

   for(int i=0; i<size; i++)
     {
      if(MyPictureOn[i]==pattern)
        {
         MyPictureOn[i]=0;
        }
     }

   sprite_bitmap_on = "::"+name+"BitMapON"+_Symbol;

   ResourceCreate(sprite_bitmap_on,MyPictureOn,size_x,size_y,0,0,0,COLOR_FORMAT_ARGB_NORMALIZE);

   ArrayCopy(MyPictureOff,sprite,0,0,WHOLE_ARRAY);

   pattern=(ulong(clrWhite)<<8)+255;

   size=ArraySize(MyPictureOff);

   for(int i=0; i<size; i++)
     {
      if(MyPictureOff[i]==pattern)
        {
         MyPictureOff[i]=0;
        }
     }

   sprite_bitmap_off = "::"+name+"BitMapOFF"+_Symbol;

   ResourceCreate(sprite_bitmap_off,MyPictureOff,size_x,size_y,0,0,0,COLOR_FORMAT_ARGB_NORMALIZE);

   if(ObjectFind(chart,name) >= 0)
     {
      if(!ObjectSetString(chart,name,OBJPROP_BMPFILE,0,sprite_bitmap_on))
        {
         Print(__FUNCTION__,
               ": não deu para carregar a imagem = ",GetLastError());
         return(false);
        }
      else
         retorno=true;

      if(!ObjectSetString(chart,name,OBJPROP_BMPFILE,1,sprite_bitmap_off))
        {
         Print(__FUNCTION__,
               ": não deu para carregar a imagem = ",GetLastError());
         return(false);
        }
      else
         retorno=true;
     }

   bitmap_state = sprite_bitmap_on;

   return(retorno);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::ResourceCreateForOBJ(const uint &resource[], const string name_resource, int x_size, int y_size)
  {
   uint resource_to_png[];

   ZeroMemory(resource_to_png);

   ArrayCopy(resource_to_png,resource,0,0,WHOLE_ARRAY);

   ulong pattern=(ulong(clrWhite)<<8)+255;

   int size=ArraySize(resource_to_png);

   for(int i=0; i<size; i++)
     {
      if(resource_to_png[i]==pattern)
        {
         resource_to_png[i]=0;
        }
     }

   if(!ResourceCreate(name_resource,resource_to_png,x_size,y_size,0,0,0,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      Print("Error to Create Resource: "+name_resource+"    Error: "+string(GetLastError()));
      return(false);
     }
   else
      return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Object::SetLoopSprites(const string &sprites[], const double speed_sprite)
  {
   if(sprites[0] != sprites_actual[0])
     {
      sprites_actual[0] = sprites[0];
      count_sprites = 0;
     }

   if(count_sprites <= 0.0)
     {
      bool is_exist = false;

      for(int i = 0; i < ArraySize(sprites)-1; i++)
        {
         if(sprites[i] == sprite_actual)
           {
            if(i == ArraySize(sprites)-1)
               SetSpriteObject(sprites[0]);
            else
               sprite_actual = sprites[i+1];

            is_exist=true;
            break;
           }
        }

      if(!is_exist)
        {
         SetSpriteObject(sprites[0]);
         sprite_actual = sprites[0];
        }
      else
         SetSpriteObject(sprite_actual);

      count_sprites = speed_sprite;
     }
   else
      count_sprites-=FixedDeltaTime();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::Destroy(void)
  {
   if(ObjectDelete(chart,name) && ObjectDelete(chart,name+"Apparence"))
      return(true);
   else
      return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::ModifyObject(int posx,int posy,int sizex,int sizey)
  {
   ObjectSetInteger(chart,name,OBJPROP_XDISTANCE,posx);
   ObjectSetInteger(chart,name,OBJPROP_YDISTANCE,posy);
   ObjectSetInteger(chart,name,OBJPROP_XSIZE,sizex);
   ObjectSetInteger(chart,name,OBJPROP_YSIZE,sizey);

   pos_x = posx;
   pos_y = posy;

   size_x = sizex;
   size_y = sizey;

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Object::MoveObjectLinear(int objective_x, int objective_y, int speed_linear, bool comment_st)
  {

   for(int i = speed_linear; i > 0; i--)
     {
      bool setobjective=false;

      if(objective_x != objective_x_ant || objective_y != objective_y_ant)
        {
         objective_x_ant=objective_x;
         objective_y_ant=objective_y;
         setobjective=true;
        }

      int distance_x=0, distance_y=0;

      bool left=false, right=false, up=false, down=false;

      if(pos_x > objective_x)
        {
         distance_x = (int)pos_x-objective_x;
         left=true;
        }
      if(pos_x < objective_x)
        {
         distance_x = objective_x-(int)pos_x;
         right=true;
        }

      if(pos_y > objective_y)
        {
         distance_y = (int)pos_y-objective_y;
         up=true;
        }
      if(pos_y < objective_y)
        {
         distance_y = objective_y-(int)pos_y;
         down=true;
        }

      if(setobjective)
        {
         if(distance_y != 0)
            interval_x=distance_x/distance_y;
         else
            interval_x=distance_x;

         if(distance_x != 0)
            interval_y=distance_y/distance_x;
         else
            interval_y=distance_y;

         if(interval_y == 0)
            interval_y=-1;
         if(interval_x == 0)
            interval_x=-1;

         interval_x_ant=interval_x;
         interval_y_ant=interval_y;
        }

      if(right && up)
        {
         if(interval_x > interval_y)
           {
            if(interval_x > 0)
              {
               pos_x+=(int)speed_object;
               interval_x--;
              }
            else
              {
               pos_y-=(int)speed_object;
               interval_x=interval_x_ant;
               setobjective=true;
              }
           }
         else
            if(interval_x < interval_y)
              {
               if(interval_y > 0)
                 {
                  pos_y-=(int)speed_object;
                  interval_y--;
                 }
               else
                 {
                  pos_x+=(int)speed_object;
                  interval_y=interval_y_ant;
                  setobjective=true;
                 }
              }
            else
              {
               pos_y-=(int)speed_object;
               pos_x+=(int)speed_object;
              }
        }
      else
         if(right && down)
           {
            if(interval_x > interval_y)
              {
               if(interval_x > 0)
                 {
                  pos_x+=(int)speed_object;
                  interval_x--;
                 }
               else
                 {
                  pos_y+=(int)speed_object;
                  interval_x=interval_x_ant;
                  setobjective=true;
                 }
              }
            else
               if(interval_x < interval_y)
                 {
                  if(interval_y > 0)
                    {
                     pos_y+=(int)speed_object;
                     interval_y--;
                    }
                  else
                    {
                     pos_x+=(int)speed_object;
                     interval_y=interval_y_ant;
                     setobjective=true;
                    }
                 }
               else
                 {
                  pos_y+=(int)speed_object;
                  pos_x+=(int)speed_object;
                 }
           }
         else
            if(left && down)
              {
               if(interval_x > interval_y)
                 {
                  if(interval_x > 0)
                    {
                     pos_x-=(int)speed_object;
                     interval_x--;
                    }
                  else
                    {
                     pos_y+=(int)speed_object;
                     interval_x=interval_x_ant;
                     setobjective=true;
                    }
                 }
               else
                  if(interval_x < interval_y)
                    {
                     if(interval_y > 0)
                       {
                        pos_y+=(int)speed_object;
                        interval_y--;
                       }
                     else
                       {
                        pos_x-=(int)speed_object;
                        interval_y=interval_y_ant;
                        setobjective=true;
                       }
                    }
                  else
                    {
                     pos_y+=(int)speed_object;
                     pos_x-=(int)speed_object;
                    }
              }
            else
               if(left && up)
                 {
                  if(interval_x > interval_y)
                    {
                     if(interval_x > 0)
                       {
                        pos_x-=(int)speed_object;
                        interval_x--;
                       }
                     else
                       {
                        pos_y-=(int)speed_object;
                        interval_x=interval_x_ant;
                        setobjective=true;
                       }
                    }
                  else
                     if(interval_x < interval_y)
                       {
                        if(interval_y > 0)
                          {
                           pos_y-=(int)speed_object;
                           interval_y--;
                          }
                        else
                          {
                           pos_x-=(int)speed_object;
                           interval_y=interval_y_ant;
                           setobjective=true;
                          }
                       }
                     else
                       {
                        pos_y-=(int)speed_object;
                        pos_x-=(int)speed_object;
                       }
                 }
               else
                 {
                  if(right)
                     pos_x+=(int)speed_object;
                  if(left)
                     pos_y-=(int)speed_object;
                  if(up)
                     pos_y-=(int)speed_object;
                  if(down)
                     pos_y+=(int)speed_object;
                 }
      if(setobjective)
        {
         if(distance_y != 0)
            interval_x=distance_x/distance_y;
         if(distance_x != 0)
            interval_y=distance_y/distance_x;
         if(interval_y == 0)
            interval_y=-1;
         if(interval_x == 0)
            interval_x=-1;
         interval_x_ant=interval_x;
         interval_y_ant=interval_y;
        }

      if(comment_st)
         Comment("Left: ",left,"\nRight: ",right,"\nUP: ",up,"\nDown: ",down,"\n\nInterval X: ",interval_x,"\nInterval Y: ",interval_y,
                 "\n\nDistance X: ",distance_x, "\nDistance Y: ",distance_y);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Object::TotalsInstances(void)
  {
   int rtrn = 0;

   for(int i = ObjectsTotal(chart,-1,-1)-1; i >= 0; i--)
     {
      if(StringFind(ObjectName(chart,i,-1,-1),name,0) >= 0)
         rtrn+=1;
     }

   return(rtrn);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Object::DestroyAllInstances(void)
  {
   int rtrn = 0;

   for(int i = ObjectsTotal(chart,-1,-1)-1; i >= 0; i--)
     {
      if(StringFind(ObjectName(chart,i,-1,-1),name,0) >= 0)
         ObjectDelete(chart,ObjectName(chart,i,-1,-1));
     }
  }




//+------------------------------------------------------------------+
//|                          CAMERA CLASS                            |
//+------------------------------------------------------------------+
class Camera
  {
public:
   Object            follow;
   bool              in_movement;

private:
   double            pos_x;
   double            pos_y;
   double            delay_count;

public:
   bool              MoveCamera(Object &expetions[], bool move_right, bool move_left, bool move_up, bool move_down, double delay, double speed);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Camera::MoveCamera(Object &to_move[], bool move_right, bool move_left, bool move_up, bool move_down, double delay, double speed)
  {

   if(move_right)
     {
      if(delay != 0 || speed != 0)
        {
         if(pos_x >= 100)
            for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
              {
               int posx=0;

               if(i >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-1 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-2 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-3 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-4 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-5 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-6 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-7 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-8 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-9 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-10 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-11 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-12 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-13 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-14 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-15 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-16 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-17 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-18 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }

               if(i-19 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
                 }
              }
        }
      else
         for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
           {
            int posx=0;

            if(i >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-1 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-2 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-3 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-4 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-5 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-6 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-7 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-8 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-9 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-10 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-11 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-12 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-13 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-14 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-15 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-16 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-17 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-18 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }

            if(i-19 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
              }
           }
     }

   if(move_left)
     {
      if(delay != 0 || speed != 0)
        {
         if(pos_x <= -100)
            for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
              {
               int posx=0;

               if(i >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-1 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-2 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-3 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-4 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-5 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-6 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-7 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-8 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-9 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-10 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-11 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-12 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-13 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-14 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-15 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-16 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-17 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-18 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }

               if(i-19 >= 0)
                 {
                  posx = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE);
                  ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
                 }
              }
        }
      else
         for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
           {
            int posx=0;

            if(i >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-1 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-2 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-3 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-4 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-5 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-6 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-7 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-8 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-9 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-10 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-11 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-12 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-13 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-14 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-15 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-16 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-17 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-18 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }

            if(i-19 >= 0)
              {
               posx = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE);
               ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
              }
           }
     }

   if(move_up)
     {
      if(delay != 0 || speed != 0)
        {
        if(pos_y <= -50)
         for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
           {
            int posy=0;

            if(i >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-1 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-2 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-3 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-4 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-5 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-6 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-7 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-8 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-9 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-10 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-11 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-12 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-13 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-14 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-15 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-16 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-17 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-18 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-19 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }
           }
        }
      else
         for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
           {
            int posy=0;

            if(i >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-1 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-2 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-3 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-4 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-5 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-6 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-7 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-8 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-9 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-10 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-11 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-12 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-13 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-14 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-15 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-16 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-17 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-18 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }

            if(i-19 >= 0)
              {
               posy = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE);
               ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
              }
           }
     }

   if(move_down)
     {
      if(delay != 0 || speed != 0)
        {
         if(pos_y >= 50)
            for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
              {
               int posy=0;

               if(i >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-1 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-2 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-3 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-4 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-5 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-6 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-7 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-8 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-9 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-10 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-11 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-12 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-13 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-14 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-15 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-16 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-17 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-18 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-19 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
              }
        }
      else
         for(int i = ArraySize(to_move)-1; i >= 0; i-=20)
              {
               int posy=0;

               if(i >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-1 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-1].chart,to_move[i-1].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-2 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-2].chart,to_move[i-2].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-3 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-3].chart,to_move[i-3].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-4 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-4].chart,to_move[i-4].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-5 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-5].chart,to_move[i-5].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-6 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-6].chart,to_move[i-6].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-7 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-7].chart,to_move[i-7].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-8 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-8].chart,to_move[i-8].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-9 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-9].chart,to_move[i-9].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }

               if(i-10 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-10].chart,to_move[i-10].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-11 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-11].chart,to_move[i-11].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-12 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-12].chart,to_move[i-12].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-13 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-13].chart,to_move[i-13].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-14 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-14].chart,to_move[i-14].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-15 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-15].chart,to_move[i-15].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-16 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-16].chart,to_move[i-16].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-17 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-17].chart,to_move[i-17].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-18 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-18].chart,to_move[i-18].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
               
               if(i-19 >= 0)
                 {
                  posy = (int)ObjectGetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE);
                  ObjectSetInteger(to_move[i-19].chart,to_move[i-19].name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
                 }
              }
     }

   if(move_up || move_right || move_left || move_down)
      in_movement=true;
   else
      in_movement=false;

   int posy = (int)ObjectGetInteger(ChartID(),follow.name,OBJPROP_YDISTANCE);
   int posx = (int)ObjectGetInteger(ChartID(),follow.name,OBJPROP_XDISTANCE);


   if(delay != 0 || speed != 0)
     {
      if(in_movement)
        {
         if(move_down)
           {
            if(pos_y < 50)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_YDISTANCE,int(posy-follow.speed_object));
               pos_y++;
              }
           }
         if(move_up)
           {
            if(pos_y > -50)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_YDISTANCE,int(posy+follow.speed_object));
               pos_y--;
              }
           }
         if(move_right)
           {
            if(pos_x < 100)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_XDISTANCE,int(posx+follow.speed_object));
               pos_x++;
              }
           }
         if(move_left)
           {
            if(pos_x > -100)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_XDISTANCE,int(posx-follow.speed_object));
               pos_x--;
              }
           }

         delay_count = delay;
        }
      else
        {
         if(delay_count < 0)
           {
            if(pos_x > speed)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_XDISTANCE,int(posx-follow.speed_object*speed));
               pos_x-=speed;

               for(int i = ArraySize(to_move)-1; i >= 0; i--)
                 {
                  int posx_obj = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);

                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx_obj-follow.speed_object*speed));
                 }
              }

            if(pos_x < -speed)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_XDISTANCE,int(posx+follow.speed_object*speed));
               pos_x+=speed;

               for(int i = ArraySize(to_move)-1; i >= 0; i--)
                 {
                  int posx_obj = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE);

                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_XDISTANCE,int(posx_obj+follow.speed_object*speed));
                 }
              }

            if(pos_y > speed)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_YDISTANCE,int(posy+follow.speed_object*speed));
               pos_y-=speed;

               for(int i = ArraySize(to_move)-1; i >= 0; i--)
                 {
                  int posy_obj = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);

                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy_obj+follow.speed_object*speed));
                 }
              }

            if(pos_y < -speed)
              {
               ObjectSetInteger(ChartID(),follow.name,OBJPROP_YDISTANCE,int(posy-follow.speed_object*speed));
               pos_y+=speed;

               for(int i = ArraySize(to_move)-1; i >= 0; i--)
                 {
                  int posy_obj = (int)ObjectGetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE);

                  ObjectSetInteger(to_move[i].chart,to_move[i].name,OBJPROP_YDISTANCE,int(posy_obj-follow.speed_object*speed));
                 }
              }
           }
         else
            delay_count-=FixedDeltaTime();
        }
     }

   return(true);
  }



//+------------------------------------------------------------------+
//|                        OTHERS FEATURES                           |
//+------------------------------------------------------------------+
int deg(double value)
  {
   return((int)fmod(value/M_PI*180,360));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double rad(double degrees)
  {
   return (degrees * (M_PI / 180));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int pt_dir(double x1, double y1, double x2, double y2)
  {
   return(deg(atan2(y2-y1, x2-x1))%360);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lendir_x(double len, double dir)
  {
   return (len * cos(rad(dir)));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lendir_y(double len, double dir)
  {
   return (len * sin(rad(dir)));
  }
//+------------------------------------------------------------------+
double clamp(double x, double min, double max)
  {
   if(x < min && min)
      return(min);
   else
      if(x > max && max)
         return(max);
      else
         if(x)
            return(x);

   return (0);
  }
//+------------------------------------------------------------------+
void AddValueArray(Object &array[], Object &value)
  {
   ArrayResize(array,ArraySize(array)+1);
   array[ArraySize(array)-1] = value;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ResourceOnArray(string name_resource, uint &array_r[])
  {
   int x_size_f, y_size_f;
   return(ResourceReadImage(name_resource,array_r,x_size_f,y_size_f));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BasicInit(UI &_ui)
  {
   ChartSetInteger(ChartID(),CHART_FOREGROUND,false);
   ChartSetInteger(ChartID(),CHART_KEYBOARD_CONTROL,false);
   ChartSetInteger(ChartID(),CHART_EVENT_MOUSE_MOVE,true);
   ChartSetInteger(ChartID(),CHART_MOUSE_SCROLL,false);
   ChartSetInteger(ChartID(),CHART_QUICK_NAVIGATION,false);
   ChartSetInteger(ChartID(),CHART_SCALE,5);
   ChartSetInteger(ChartID(),CHART_SHOW,false);
   ChartSetInteger(ChartID(),CHART_IS_DOCKED,false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BasicDeinit(UI &_ui)
  {
   ChartSetInteger(ChartID(),CHART_KEYBOARD_CONTROL,true);
   ChartSetInteger(ChartID(),CHART_EVENT_MOUSE_MOVE,false);
   ChartSetInteger(ChartID(),CHART_MOUSE_SCROLL,true);
   ChartSetInteger(ChartID(),CHART_QUICK_NAVIGATION,true);
   ChartSetInteger(ChartID(),CHART_SCALE,3);
   ChartSetInteger(ChartID(),CHART_SHOW,true);
   ChartSetInteger(ChartID(),CHART_IS_DOCKED,true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CommentLab(string CommentText)
  {
   string label_name;
   int CommentIndex = 0;

   label_name = "CommentDEBUG";

   if(CommentText == "")
     {
      while(ObjectFind(0,label_name) >= 0)
        {
         ObjectDelete(0,label_name);
         CommentIndex++;
        }
     }

   if(ObjectFind(0,label_name) < 0)
      ObjectCreate(0,label_name,OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,label_name, OBJPROP_CORNER, 0);
   ObjectSetInteger(0,label_name,OBJPROP_XDISTANCE,20);
   ObjectSetInteger(0,label_name,OBJPROP_YDISTANCE,50);
   ObjectSetInteger(0,label_name,OBJPROP_COLOR,clrGoldenrod);
   ObjectSetString(0,label_name,OBJPROP_TEXT,CommentText);
   ObjectSetString(0,label_name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,label_name,OBJPROP_FONTSIZE,18);
   ObjectSetInteger(0,label_name,OBJPROP_SELECTABLE,true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NumberToCodigo(int number)
  {
   string rtrn = NULL;


   string codigo[10] = {"QNR32dcnv[wepw´[erpw[´rpfnQskniierw83","nfiu][we[flw[léwpwépr´[wepw´[erpw[´rpfnQRN834y8324jdd","fQRN38[wepw´[erpw[´rpfnQ2nkdfsnvmserokg","F)(U()FEFEFmkfmdQRNoewkd","fbjfnvsiefj43f[wepw´[erpw[´rpfnQwefwerQRNhhf",
                        "ncdcjs[wepw´[erpw[´rpfnQueeiqo","jiwjfeoiQ*(*(Y*(QRDNNfjw","ijfiQRNojweirimi[wepw´[erpw[´rpfnQmvwioewoiejr0392u9032i94[wepw´[erpw[´rpfnQ8920321emcce","iefjwo73y7423y7NQRejfwffe","jnqw23234jrnejleQRNkwfe[wepw´[erpw[´rpfnQfwwfekcvkvmopwq[wepw´[34erpw[´rpfnQ343ke"
                       };

   string number_str = (string)number;

   int len = StringLen(number_str);

   int numbers[];

   ZeroMemory(numbers);

   for(int i = 0; i < len; i++)
     {
      int number_actual = (int)StringSubstr(number_str,i,1);

      ArrayResize(numbers,ArraySize(numbers)+1,0);
      ArrayFill(numbers,ArraySize(numbers)-1,1,number_actual);
     }

   for(int j = 0; j < ArraySize(numbers); j++)
     {
      string soma = codigo[numbers[j]];

      rtrn+=soma;
     }

   return(rtrn);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CodigoToNumber(string Codigo)
  {
   string codigo[10] = {"QNR32dcnv[wepw´[erpw[´rpfnQskniierw83","nfiu][we[flw[léwpwépr´[wepw´[erpw[´rpfnQRN834y8324jdd","fQRN38[wepw´[erpw[´rpfnQ2nkdfsnvmserokg","F)(U()FEFEFmkfmdQRNoewkd","fbjfnvsiefj43f[wepw´[erpw[´rpfnQwefwerQRNhhf",
                        "ncdcjs[wepw´[erpw[´rpfnQueeiqo","jiwjfeoiQ*(*(Y*(QRDNNfjw","ijfiQRNojweirimi[wepw´[erpw[´rpfnQmvwioewoiejr0392u9032i94[wepw´[erpw[´rpfnQ8920321emcce","iefjwo73y7423y7NQRejfwffe","jnqw23234jrnejleQRNkwfe[wepw´[erpw[´rpfnQfwwfekcvkvmopwq[wepw´[34erpw[´rpfnQ343ke"
                       };

   int len = StringLen(Codigo);

   string number = NULL;

   int pos_ant = 0;

   for(int i = 0; i < len+1; i++)
     {
      string find_cod = StringSubstr(Codigo,pos_ant,i-pos_ant);

      for(int k = ArraySize(codigo)-1; k >= 0; k--)
        {
         if(find_cod == codigo[k])
           {
            number+=(string)k;
            pos_ant = i;
           }
        }
     }
   return((int)number);
  }
//+------------------------------------------------------------------+
