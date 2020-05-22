# set the default encoding
bleopt input_encoding=UTF-8

#define the pager to be used
bleopt pager=less

# use colors defined by LS_COLORS where applicable
bleopt filename_ls_colors="$LS_COLORS"

# define auto-suggestion text color
ble-color-setface auto_complete fg=242

# define alias text-color
ble-color-setface command_alias fg=teal

# define function text-color
ble-color-setface command_function fg=teal
