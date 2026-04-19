swayimg.text.hide()
swayimg.imagelist.set_order("mtime")
swayimg.imagelist.enable_reverse(true)
swayimg.imagelist.enable_fsmon(true)
swayimg.viewer.set_default_scale("fit")
swayimg.gallery.set_aspect("keep")
swayimg.gallery.set_thumb_size(200)
swayimg.gallery.set_selected_scale(2.0)
swayimg.viewer.bind_reset()
swayimg.gallery.bind_reset()
swayimg.gallery.set_mark_color(0xffff0000)
swayimg.viewer.set_mark_color(0xffff0000)
swayimg.on_initialized(function()
                           swayimg.set_mode("viewer")
                           swayimg.viewer.switch_image("first")
                       end)

swayimg.viewer.on_key("j",
                      function()
                          swayimg.viewer.switch_image("next")
                      end)

swayimg.viewer.on_key("k",
                      function()
                          swayimg.viewer.switch_image("prev")
                      end)
swayimg.gallery.on_key("j",
                      function()
                          swayimg.gallery.switch_image("down")
                      end)

swayimg.gallery.on_key("k",
                      function()
                          swayimg.gallery.switch_image("up")
                      end)
swayimg.gallery.on_key("h",
                      function()
                          swayimg.gallery.switch_image("left")
                      end)
swayimg.gallery.on_key("l",
                      function()
                          swayimg.gallery.switch_image("right")
                      end)


swayimg.viewer.on_key("m",
                      function()
                          swayimg.viewer.mark_image()
                      end)

swayimg.gallery.on_key("m",
                      function()
                          swayimg.gallery.mark_image()
                      end)

swayimg.viewer.on_key("q",
                      function()
                          swayimg.exit()
                      end)

swayimg.gallery.on_key("q",
                      function()
                          swayimg.exit()
                      end)


swayimg.viewer.on_key("x",
                      function()
                           local imagelist = swayimg.imagelist.get()
                           for _, image in ipairs(imagelist) do
                               if image.mark then
                                   os.remove(image.path)
                               end
                           end
                       end)
swayimg.gallery.on_key("x",
                      function()
                           local imagelist = swayimg.imagelist.get()
                           for _, image in ipairs(imagelist) do
                               if image.mark then
                                   os.remove(image.path)
                               end
                           end
                       end)

swayimg.viewer.on_key("g",
                       function()
                           swayimg.set_mode("gallery")
                       end)
swayimg.gallery.on_key("g",
                       function()
                           swayimg.set_mode("viewer")
                       end)


swayimg.viewer.on_key("y",
                      function()
                          local image = swayimg.viewer.get_image()
                          os.execute("magick " .. image.path .. " PNG:- | wl-copy")
                          swayimg.text.set_status("Copied to clipboard")
                      end)




