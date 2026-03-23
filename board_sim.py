import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
import pygame
import sys
import re
import time
from pathlib import Path

def get_bit_index(name):
    nums = re.findall(r'\d+', name)
    return int(nums[0]) if nums else 0

# 1. Initialize Pygame
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
pygame.display.init()
pygame.font.init()
LABEL_FONT = pygame.font.SysFont(None, 20)
screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT)) 
pygame.display.set_caption("Board Simulator")

# 2. Load Background Image
proj_path = Path(__file__).resolve().parent
try:
    raw_image = pygame.image.load(str(proj_path / "board_bg.png"))
    bg_image = pygame.transform.smoothscale(raw_image, (WINDOW_WIDTH, WINDOW_HEIGHT))
except pygame.error:
    print("Error: Could not load board_bg.png.")
    sys.exit(1)

# 3. Define Coordinates and Constants
LED_RADIUS = 5
BUTTON_RADIUS = 12
SEG_RADIUS = 3

LEDS = [
    {"pos": (154, 290), "color_on": (0, 255, 0), "color_off": (0, 50, 0), "state": 0, "name": "led0", "y_offset": -20},
    {"pos": (186, 290), "color_on": (0, 255, 0), "color_off": (0, 50, 0), "state": 0, "name": "led1", "y_offset": -20},
    {"pos": (215, 290), "color_on": (0, 255, 0), "color_off": (0, 50, 0), "state": 0, "name": "led2", "y_offset": -20},
    {"pos": (248, 290), "color_on": (0, 255, 0), "color_off": (0, 50, 0), "state": 0, "name": "led3", "y_offset": -20},
    {"pos": (364, 523), "color_on": (255, 0, 0), "color_off": (50, 0, 0), "state": 0, "name": "led4", "y_offset": 20},
    {"pos": (378, 523), "color_on": (255, 0, 0), "color_off": (50, 0, 0), "state": 0, "name": "led5", "y_offset": 35},
    {"pos": (391, 523), "color_on": (255, 0, 0), "color_off": (50, 0, 0), "state": 0, "name": "led6", "y_offset": 20},
    {"pos": (407, 523), "color_on": (255, 0, 0), "color_off": (50, 0, 0), "state": 0, "name": "led7", "y_offset": 35},
]

BUTTONS = [
    {"pos": (385, 338), "pressed": False, "name": "btn0", "y_offset": -25},
    {"pos": (432, 338), "pressed": False, "name": "btn1", "y_offset": -25},
    {"pos": (475, 338), "pressed": False, "name": "btn2", "y_offset": -25},
    {"pos": (519, 338), "pressed": False, "name": "btn3", "y_offset": -25},
]

SWITCHES = [
    {"rect": pygame.Rect(131, 313, 20, 46), "state": 0, "name": "sw0", "y_offset": 35},
    {"rect": pygame.Rect(163, 313, 20, 46), "state": 0, "name": "sw1", "y_offset": 35},
    {"rect": pygame.Rect(198, 313, 20, 46), "state": 0, "name": "sw2", "y_offset": 35},
    {"rect": pygame.Rect(232, 313, 20, 46), "state": 0, "name": "sw3", "y_offset": 35},
    {"rect": pygame.Rect(651, 332, 26, 44), "state": 0, "name": "sw4", "y_offset": 35},
    {"rect": pygame.Rect(687, 332, 26, 44), "state": 0, "name": "sw5", "y_offset": 35},
    {"rect": pygame.Rect(720, 332, 26, 44), "state": 0, "name": "sw6", "y_offset": 35},
    {"rect": pygame.Rect(751, 332, 26, 44), "state": 0, "name": "sw7", "y_offset": 35},
]

SEG_A = [
    {"type": "poly", "points": [(176, 502), (197, 502), (195, 506), (174, 506)], "state": 0, "name": "seg0"}, 
    {"type": "poly", "points": [(198, 505), (202, 505), (197, 525), (193, 525)], "state": 0, "name": "seg1"}, 
    {"type": "poly", "points": [(196, 529), (200, 529), (194, 551), (190, 551)], "state": 0, "name": "seg2"}, 
    {"type": "poly", "points": [(172, 551), (191, 551), (189, 555), (170, 555)], "state": 0, "name": "seg3"}, 
    {"type": "poly", "points": [(169, 529), (173, 529), (167, 551), (163, 551)], "state": 0, "name": "seg4"}, 
    {"type": "poly", "points": [(171, 505), (175, 505), (170, 525), (166, 525)], "state": 0, "name": "seg5"}, 
    {"type": "poly", "points": [(174, 526), (194, 526), (192, 530), (172, 530)], "state": 0, "name": "seg6"}, 
    {"type": "circle", "pos": (204, 554), "state": 0, "name": "seg7"}
]

SEG_B = [
    {"type": "poly", "points": [(226, 502), (247, 502), (245, 506), (224, 506)], "state": 0, "name": "seg0"}, 
    {"type": "poly", "points": [(248, 505), (252, 505), (247, 525), (243, 525)], "state": 0, "name": "seg1"}, 
    {"type": "poly", "points": [(246, 529), (250, 529), (244, 551), (240, 551)], "state": 0, "name": "seg2"}, 
    {"type": "poly", "points": [(222, 551), (241, 551), (239, 555), (220, 555)], "state": 0, "name": "seg3"}, 
    {"type": "poly", "points": [(219, 529), (223, 529), (217, 551), (213, 551)], "state": 0, "name": "seg4"}, 
    {"type": "poly", "points": [(221, 505), (225, 505), (220, 525), (216, 525)], "state": 0, "name": "seg5"}, 
    {"type": "poly", "points": [(224, 526), (244, 526), (242, 530), (222, 530)], "state": 0, "name": "seg6"}, 
    {"type": "circle", "pos": (254, 554), "state": 0, "name": "seg7"}
]

@cocotb.test()
async def run_visualizer(dut):
    # START CLOCK COROUTINE
    # 125 MHz = 8 ns period. We check for common Zybo clock names.
    if hasattr(dut, "clk"):
        cocotb.start_soon(Clock(dut.clk, 8, unit="ns").start())
    elif hasattr(dut, "sysclk"):
        cocotb.start_soon(Clock(dut.sysclk, 8, unit="ns").start())

    pygame_clock = pygame.time.Clock()
    running = True
    
    while running:
        # A. Handle Pygame Events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mx, my = event.pos
                for btn in BUTTONS:
                    bx, by = btn["pos"]
                    if (mx - bx)**2 + (my - by)**2 <= BUTTON_RADIUS**2:
                        btn["pressed"] = True
                for sw in SWITCHES:
                    if sw["rect"].collidepoint(event.pos):
                        sw["state"] = 1 if sw["state"] == 0 else 0
            elif event.type == pygame.MOUSEBUTTONUP:
                for btn in BUTTONS:
                    btn["pressed"] = False

        # B. Send Inputs to VHDL
        sw_int = sum([sw["state"] << get_bit_index(sw["name"]) for sw in SWITCHES])
        btn_int = sum([(1 if btn["pressed"] else 0) << get_bit_index(btn["name"]) for btn in BUTTONS])

        if hasattr(dut, "sw"):
            try: dut.sw.value = sw_int & ((1 << len(dut.sw)) - 1)
            except Exception: pass
                
        if hasattr(dut, "btn"):
            try: dut.btn.value = btn_int & ((1 << len(dut.btn)) - 1)
            except Exception: pass

        for sw in SWITCHES:
            scalar_name = f"sw{get_bit_index(sw['name'])}"
            if hasattr(dut, scalar_name):
                try: getattr(dut, scalar_name).value = sw["state"]
                except Exception: pass
                
        for btn in BUTTONS:
            scalar_name = f"btn{get_bit_index(btn['name'])}"
            if hasattr(dut, scalar_name):
                try: getattr(dut, scalar_name).value = 1 if btn["pressed"] else 0
                except Exception: pass

        # C. Advance VHDL Simulation
        # Instead of 1 massive jump, we take small steps and yield control back to Pygame frequently
        await Timer(10, unit="us")

        # D. Read Outputs from VHDL
        led_int, seg_int = 0, 0
        if hasattr(dut, "led"):
            try: led_int = int(dut.led.value)
            except ValueError: pass
            
        if hasattr(dut, "seg"):
            try: seg_int = int(dut.seg.value)
            except ValueError: pass

        cat_val = 0
        if hasattr(dut, "cat"):
            try: cat_val = 1 if str(dut.cat.value) == '1' else 0
            except Exception: pass

        for led in LEDS:
            idx = get_bit_index(led["name"])
            scalar_name = f"led{idx}"
            if hasattr(dut, scalar_name):
                try: led["state"] = 1 if str(getattr(dut, scalar_name).value) == '1' else 0
                except Exception: led["state"] = 0
            elif hasattr(dut, "led"):
                led["state"] = (led_int >> idx) & 1

        for seg in SEG_A:
            idx = get_bit_index(seg["name"])
            scalar_name = f"seg{idx}"
            state = 0
            if hasattr(dut, scalar_name):
                try: state = 1 if str(getattr(dut, scalar_name).value) == '1' else 0
                except Exception: pass
            elif hasattr(dut, "seg"):
                state = (seg_int >> idx) & 1
            seg["state"] = 1 if (state == 1 and cat_val == 0) else 0

        for seg in SEG_B:
            idx = get_bit_index(seg["name"])
            scalar_name = f"seg{idx}"
            state = 0
            if hasattr(dut, scalar_name):
                try: state = 1 if str(getattr(dut, scalar_name).value) == '1' else 0
                except Exception: pass
            elif hasattr(dut, "seg"):
                state = (seg_int >> idx) & 1
            seg["state"] = 1 if (state == 1 and cat_val == 1) else 0

        # E. Draw Everything
        screen.blit(bg_image, (0, 0))
        
        for sw in SWITCHES:
            pygame.draw.rect(screen, (150, 150, 150), sw["rect"])
            th = sw["rect"].height // 3
            tr = pygame.Rect(sw["rect"].x, sw["rect"].y if sw["state"] == 1 else sw["rect"].y + sw["rect"].height - th, sw["rect"].width, th)
            pygame.draw.rect(screen, (0, 0, 0), tr)
            pygame.draw.rect(screen, (255, 255, 255), (sw["rect"].x-1, sw["rect"].y-1, sw["rect"].width+2, sw["rect"].height+2), 1)
            ts = LABEL_FONT.render(sw["name"], True, (255, 255, 255), (0, 0, 0))
            screen.blit(ts, ts.get_rect(center=(sw["rect"].centerx, sw["rect"].centery + sw["y_offset"])))

        for led in LEDS:
            c = led["color_on"] if led["state"] == 1 else led["color_off"]
            pygame.draw.circle(screen, c, led["pos"], LED_RADIUS)
            pygame.draw.circle(screen, (255, 255, 255), led["pos"], LED_RADIUS+1, 1)
            ts = LABEL_FONT.render(led["name"], True, (255, 255, 255), (0, 0, 0))
            screen.blit(ts, ts.get_rect(center=(led["pos"][0], led["pos"][1] + led["y_offset"])))

        for btn in BUTTONS:
            c = (150, 150, 150) if btn["pressed"] else (0, 0, 0)
            pygame.draw.circle(screen, c, btn["pos"], BUTTON_RADIUS)
            pygame.draw.circle(screen, (255, 255, 255), btn["pos"], BUTTON_RADIUS+1, 1)
            ts = LABEL_FONT.render(btn["name"], True, (255, 255, 255), (0, 0, 0))
            screen.blit(ts, ts.get_rect(center=(btn["pos"][0], btn["pos"][1] + btn["y_offset"])))

        for d in [SEG_A, SEG_B]:
            for s in d:
                c = (255, 0, 0) if s["state"] == 1 else (50, 0, 0)
                if s["type"] == "poly":
                    pygame.draw.polygon(screen, c, s["points"])
                    pygame.draw.polygon(screen, (255, 255, 255), s["points"], 1)
                else:
                    pygame.draw.circle(screen, c, s["pos"], SEG_RADIUS)
                    pygame.draw.circle(screen, (255, 255, 255), s["pos"], SEG_RADIUS+1, 1)
        
        pygame.display.flip()
        pygame_clock.tick(60) # Ensure a smooth 60 FPS update rate for the GUI
    
    pygame.quit()