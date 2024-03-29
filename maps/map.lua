return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 30,
  height = 20,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 4,
  nextobjectid = 6,
  properties = {},
  tilesets = {
    {
      name = "tileset",
      firstgid = 1,
      class = "",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "tileset.png",
      imagewidth = 256,
      imageheight = 256,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 256,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 30,
      height = 20,
      id = 1,
      name = "floor",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      chunks = {
        {
          x = -16, y = -16, width = 16, height = 16,
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 114, 129, 98, 102, 99, 117, 114, 102, 118, 117,
            0, 0, 0, 0, 0, 0, 119, 116, 134, 135, 113, 97, 131, 132, 102, 135,
            0, 0, 0, 0, 0, 0, 99, 117, 131, 115, 97, 129, 119, 116, 104, 98,
            0, 0, 0, 0, 0, 0, 118, 100, 98, 97, 132, 136, 113, 120, 117, 114,
            0, 0, 0, 0, 0, 0, 103, 102, 98, 134, 98, 119, 134, 100, 132, 103,
            0, 0, 0, 0, 0, 0, 130, 103, 98, 97, 28, 29, 30, 113, 131, 113,
            0, 0, 0, 0, 0, 0, 113, 129, 99, 129, 44, 3, 46, 133, 131, 115,
            0, 0, 0, 0, 0, 0, 134, 113, 113, 136, 60, 61, 62, 132, 97, 97,
            0, 0, 0, 0, 0, 0, 136, 129, 113, 101, 76, 77, 78, 115, 98, 119,
            0, 0, 0, 0, 0, 0, 103, 132, 114, 98, 132, 113, 120, 129, 104, 113
          }
        },
        {
          x = 0, y = -16, width = 16, height = 16,
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            135, 119, 115, 104, 98, 129, 102, 104, 130, 104, 113, 114, 134, 134, 117, 131,
            132, 136, 133, 100, 135, 100, 133, 99, 100, 118, 113, 99, 97, 114, 113, 115,
            101, 135, 133, 115, 115, 118, 97, 102, 131, 28, 29, 30, 115, 130, 113, 115,
            98, 100, 134, 115, 120, 99, 134, 118, 101, 44, 17, 46, 100, 133, 118, 115,
            101, 100, 28, 29, 30, 135, 120, 120, 133, 60, 61, 62, 136, 101, 115, 101,
            130, 134, 44, 45, 46, 130, 135, 117, 132, 76, 77, 78, 118, 115, 129, 114,
            120, 113, 60, 61, 62, 115, 131, 132, 119, 120, 101, 115, 130, 115, 130, 131,
            115, 135, 76, 77, 78, 134, 115, 99, 129, 129, 113, 102, 117, 129, 101, 117,
            104, 102, 115, 131, 135, 133, 119, 113, 99, 133, 114, 114, 134, 119, 120, 98,
            129, 118, 119, 100, 97, 101, 101, 132, 131, 116, 135, 114, 116, 131, 129, 114
          }
        },
        {
          x = 16, y = -16, width = 16, height = 16,
          data = {
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            131, 135, 134, 102, 131, 98, 116, 133, 0, 0, 0, 0, 0, 0, 0, 0,
            132, 129, 97, 113, 119, 114, 104, 119, 0, 0, 0, 0, 0, 0, 0, 0,
            100, 115, 135, 103, 133, 132, 101, 99, 0, 0, 0, 0, 0, 0, 0, 0,
            101, 134, 136, 133, 113, 116, 100, 131, 0, 0, 0, 0, 0, 0, 0, 0,
            134, 135, 102, 117, 99, 133, 117, 117, 117, 136, 0, 0, 0, 0, 0, 0,
            129, 28, 29, 30, 134, 117, 113, 104, 133, 97, 0, 0, 0, 0, 0, 0,
            104, 44, 6, 46, 129, 113, 103, 120, 135, 134, 0, 0, 0, 0, 0, 0,
            136, 60, 61, 62, 102, 118, 132, 120, 132, 97, 0, 0, 0, 0, 0, 0,
            113, 76, 77, 78, 97, 129, 131, 98, 98, 133, 0, 0, 0, 0, 0, 0,
            100, 115, 103, 100, 130, 129, 101, 130, 99, 118, 0, 0, 0, 0, 0, 0
          }
        },
        {
          x = -16, y = 0, width = 16, height = 16,
          data = {
            0, 0, 0, 0, 0, 0, 101, 116, 103, 136, 115, 102, 103, 115, 136, 129,
            0, 0, 0, 0, 0, 0, 98, 132, 118, 114, 129, 116, 117, 136, 97, 97,
            0, 0, 0, 0, 0, 0, 135, 101, 119, 120, 120, 129, 133, 129, 131, 99,
            0, 0, 0, 0, 0, 0, 132, 98, 104, 135, 135, 28, 29, 30, 100, 131,
            0, 0, 0, 0, 0, 0, 100, 114, 119, 135, 120, 44, 5, 46, 99, 131,
            0, 0, 0, 0, 0, 0, 119, 97, 131, 135, 113, 60, 61, 62, 101, 120,
            0, 0, 0, 0, 0, 0, 135, 113, 114, 101, 118, 76, 77, 78, 114, 113,
            0, 0, 0, 0, 0, 0, 134, 102, 132, 119, 99, 100, 115, 113, 98, 98,
            0, 0, 0, 0, 0, 0, 101, 102, 134, 99, 133, 116, 115, 119, 120, 133,
            0, 0, 0, 0, 0, 0, 113, 133, 28, 29, 30, 99, 114, 132, 104, 101,
            0, 0, 0, 0, 0, 0, 120, 118, 44, 21, 46, 118, 102, 100, 98, 132,
            0, 0, 0, 0, 0, 0, 119, 135, 60, 61, 62, 103, 98, 113, 104, 101,
            0, 0, 0, 0, 0, 0, 97, 135, 76, 77, 78, 117, 115, 103, 130, 133,
            0, 0, 0, 0, 0, 0, 97, 119, 103, 120, 115, 102, 119, 119, 115, 134,
            0, 0, 0, 0, 0, 0, 120, 132, 116, 129, 119, 98, 134, 98, 135, 117,
            0, 0, 0, 0, 0, 0, 115, 118, 136, 100, 117, 28, 29, 30, 99, 120
          }
        },
        {
          x = 0, y = 0, width = 16, height = 16,
          data = {
            28, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 30, 133,
            44, 38, 70, 66, 5, 7, 86, 70, 34, 51, 33, 3, 81, 39, 46, 102,
            44, 5, 84, 70, 22, 18, 6, 54, 21, 35, 66, 34, 3, 18, 46, 99,
            44, 38, 39, 7, 51, 56, 71, 49, 34, 36, 39, 7, 68, 81, 46, 103,
            44, 87, 72, 40, 38, 71, 24, 35, 51, 86, 7, 5, 50, 50, 46, 120,
            44, 65, 21, 6, 20, 49, 56, 4, 56, 67, 83, 51, 72, 52, 46, 129,
            44, 70, 65, 3, 4, 49, 67, 24, 2, 20, 40, 38, 52, 82, 46, 130,
            44, 53, 18, 70, 70, 21, 3, 81, 55, 24, 70, 56, 81, 37, 46, 135,
            44, 56, 49, 82, 52, 72, 20, 21, 70, 18, 70, 85, 65, 70, 46, 135,
            44, 87, 65, 87, 65, 35, 33, 88, 5, 52, 71, 6, 37, 50, 46, 135,
            44, 1, 22, 68, 55, 84, 65, 68, 4, 7, 39, 82, 82, 39, 46, 117,
            44, 37, 40, 33, 53, 6, 18, 50, 68, 34, 18, 38, 3, 54, 46, 98,
            44, 67, 19, 71, 65, 54, 39, 33, 5, 69, 82, 22, 2, 19, 46, 129,
            44, 23, 17, 66, 35, 34, 81, 34, 3, 6, 39, 23, 52, 81, 46, 133,
            60, 61, 61, 61, 61, 61, 61, 61, 61, 61, 61, 61, 61, 61, 62, 116,
            76, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 77, 78, 136
          }
        },
        {
          x = 16, y = 0, width = 16, height = 16,
          data = {
            114, 99, 134, 113, 114, 116, 136, 134, 130, 100, 0, 0, 0, 0, 0, 0,
            99, 102, 118, 99, 131, 136, 99, 132, 98, 114, 0, 0, 0, 0, 0, 0,
            103, 101, 131, 120, 116, 100, 132, 103, 103, 97, 0, 0, 0, 0, 0, 0,
            102, 101, 129, 115, 28, 29, 30, 98, 102, 103, 0, 0, 0, 0, 0, 0,
            114, 116, 129, 103, 44, 7, 46, 114, 132, 97, 0, 0, 0, 0, 0, 0,
            130, 100, 131, 120, 60, 61, 62, 98, 97, 99, 0, 0, 0, 0, 0, 0,
            102, 118, 113, 132, 76, 77, 78, 98, 118, 99, 0, 0, 0, 0, 0, 0,
            101, 97, 132, 113, 100, 100, 136, 104, 98, 131, 0, 0, 0, 0, 0, 0,
            117, 129, 132, 118, 101, 136, 113, 129, 97, 120, 0, 0, 0, 0, 0, 0,
            101, 101, 120, 119, 131, 116, 115, 133, 130, 117, 0, 0, 0, 0, 0, 0,
            114, 28, 29, 30, 120, 132, 120, 134, 98, 101, 0, 0, 0, 0, 0, 0,
            118, 44, 4, 46, 99, 130, 130, 118, 132, 103, 0, 0, 0, 0, 0, 0,
            100, 60, 61, 62, 116, 99, 133, 132, 129, 133, 0, 0, 0, 0, 0, 0,
            133, 76, 77, 78, 103, 133, 135, 120, 120, 104, 0, 0, 0, 0, 0, 0,
            100, 132, 117, 102, 134, 104, 103, 136, 114, 129, 0, 0, 0, 0, 0, 0,
            120, 103, 131, 114, 131, 130, 100, 100, 117, 98, 0, 0, 0, 0, 0, 0
          }
        },
        {
          x = -16, y = 16, width = 16, height = 16,
          data = {
            0, 0, 0, 0, 0, 0, 117, 114, 116, 115, 118, 44, 2, 46, 136, 98,
            0, 0, 0, 0, 0, 0, 100, 100, 100, 131, 104, 60, 61, 62, 113, 117,
            0, 0, 0, 0, 0, 0, 135, 135, 104, 99, 116, 76, 77, 78, 101, 104,
            0, 0, 0, 0, 0, 0, 97, 131, 97, 116, 117, 135, 135, 133, 119, 97,
            0, 0, 0, 0, 0, 0, 132, 136, 132, 129, 113, 119, 135, 114, 103, 132,
            0, 0, 0, 0, 0, 0, 136, 114, 113, 130, 132, 100, 103, 104, 101, 115,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        },
        {
          x = 0, y = 16, width = 16, height = 16,
          data = {
            133, 98, 118, 101, 100, 101, 97, 100, 104, 114, 133, 103, 129, 103, 134, 98,
            116, 115, 116, 132, 115, 113, 131, 98, 114, 114, 136, 28, 29, 30, 100, 135,
            120, 136, 97, 132, 120, 134, 97, 99, 136, 132, 135, 44, 18, 46, 99, 136,
            118, 120, 114, 101, 28, 29, 30, 135, 133, 136, 102, 60, 61, 62, 116, 97,
            98, 101, 117, 102, 44, 1, 46, 134, 100, 100, 129, 76, 77, 78, 99, 117,
            131, 136, 119, 118, 60, 61, 62, 129, 118, 133, 101, 116, 119, 118, 101, 120,
            0, 0, 0, 0, 76, 77, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        },
        {
          x = 16, y = 16, width = 16, height = 16,
          data = {
            102, 130, 113, 129, 131, 120, 118, 134, 130, 114, 0, 0, 0, 0, 0, 0,
            113, 118, 103, 135, 131, 116, 132, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            28, 29, 30, 114, 116, 129, 117, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            44, 17, 46, 130, 114, 102, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            60, 61, 62, 114, 120, 104, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            76, 77, 78, 99, 103, 100, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "green",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 5,
          name = "",
          class = "",
          shape = "rectangle",
          x = 1,
          y = 1,
          width = 238,
          height = 238,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "wall",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = -16,
          width = 240,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          class = "",
          shape = "rectangle",
          x = 240,
          y = 0,
          width = 16,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          class = "",
          shape = "rectangle",
          x = 0,
          y = 240,
          width = 240,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          class = "",
          shape = "rectangle",
          x = -16,
          y = 0,
          width = 16,
          height = 240,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
